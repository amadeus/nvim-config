-- AI Slop Ahead...
local function find_source_diff_window(bufnr_to_exclude)
  -- Get windows in current tabpage
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, winid in ipairs(windows) do
    if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_get_option_value("diff", { win = winid }) then
      local win_bufnr = vim.api.nvim_win_get_buf(winid)
      -- Ensure it's not the buffer we are about to close
      if win_bufnr ~= bufnr_to_exclude then
        local bufname = vim.fn.bufname(win_bufnr)
        -- Ensure it's not another fugitive buffer (e.g. Gvdiff with fugitive vs fugitive)
        if bufname and not bufname:match("^fugitive://") then
          return winid -- This is likely the source file window
        end
      end
    end
  end
  -- No suitable source window found
  return nil
end

local function find_fugitive_diff_window(source_bufnr_to_exclude)
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, winid in ipairs(windows) do
    if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_get_option_value("diff", { win = winid }) then
      local win_bufnr = vim.api.nvim_win_get_buf(winid)
      -- Ensure it's not the source buffer we are currently in
      if win_bufnr ~= source_bufnr_to_exclude then
        local bufname = vim.fn.bufname(win_bufnr)
        -- Ensure it IS a fugitive buffer
        if bufname and bufname:match("^fugitive://") then
          return winid
        end
      end
    end
  end
  return nil
end

local fold_states_by_fugitive_bufnr = {}

local function capture_fold_state(winid)
  return vim.api.nvim_win_call(winid, function()
    local view = vim.fn.winsaveview()
    local fold_state = {
      winid = winid,
      foldlevel = vim.wo.foldlevel,
      foldenable = vim.wo.foldenable,
      closed_folds = {},
    }
    vim.wo.foldenable = true

    -- foldlevel does not include manually opened folds, so save the effective view too.
    local line = 1
    local line_count = vim.api.nvim_buf_line_count(0)
    while line <= line_count do
      local fold_start = vim.fn.foldclosed(line)
      if fold_start == -1 then
        line = line + 1
      else
        fold_state.closed_folds[#fold_state.closed_folds + 1] = fold_start
        line = vim.fn.foldclosedend(line) + 1
      end
    end

    vim.wo.foldenable = fold_state.foldenable
    vim.fn.winrestview(view)
    return fold_state
  end)
end

local function restore_fold_state(fold_state)
  if not fold_state or not vim.api.nvim_win_is_valid(fold_state.winid) then
    return
  end

  vim.api.nvim_win_call(fold_state.winid, function()
    local view = vim.fn.winsaveview()
    vim.wo.foldlevel = fold_state.foldlevel
    vim.wo.foldenable = true
    -- Discard the diff's fold overrides before replaying the source window's closed folds.
    vim.cmd("silent! %foldopen!")
    local line_count = vim.api.nvim_buf_line_count(0)
    for _, fold_start in ipairs(fold_state.closed_folds) do
      if fold_start <= line_count then
        vim.api.nvim_win_set_cursor(0, { fold_start, 0 })
        vim.cmd("silent! normal! zC")
      end
    end
    vim.wo.foldenable = fold_state.foldenable
    vim.fn.winrestview(view)
  end)
end

local function SmartGvdiffToggle(diff_cmd)
  if vim.wo.diff then
    -- We are in a diff window
    local current_bufnr = vim.fn.bufnr("%")
    local current_buf_name = vim.fn.bufname(current_bufnr)
    if current_buf_name:match("^fugitive://") then
      -- Cursor is in the diff buffer, close diff and return user cursor to
      -- source file
      local source_winid_to_focus = find_source_diff_window(current_bufnr)
      vim.cmd("bd") -- Close the current (fugitive) buffer
      if source_winid_to_focus and vim.api.nvim_win_is_valid(source_winid_to_focus) then
        vim.api.nvim_set_current_win(source_winid_to_focus)
      end
    else
      -- Cursor is in the main source file's window, close diff and keep cursor
      -- in source file
      local fugitive_winid_to_close = find_fugitive_diff_window(current_bufnr)
      if fugitive_winid_to_close and vim.api.nvim_win_is_valid(fugitive_winid_to_close) then
        vim.api.nvim_win_close(fugitive_winid_to_close, false)
      end
    end
  else
    -- We are not in a diff window, initialize diff view and move cursor to
    -- source buffer. Keep Ctrl-^ pointing at the file that was alternate
    -- before Fugitive opened
    vim.cmd("keepalt " .. diff_cmd)
    vim.cmd("wincmd l")
  end
end

return {
  "tpope/vim-fugitive",
  version = false,
  config = function()
    vim.keymap.set("n", "<leader>gg", function()
      SmartGvdiffToggle("Gvdiff")
    end, { desc = "Open Gvdiff against the index or close diff pane" })
    -- Diff against HEAD -- staging hunks doesn't recompute the diff, so folds
    -- and the cursor stay put during review. With a rev argument fugitive
    -- applies no direction default and 'splitright' would reverse the panes,
    -- so force the fugitive buffer to the left
    vim.keymap.set("n", "<leader>gh", function()
      SmartGvdiffToggle("leftabove Gvdiff @")
    end, { desc = "Open Gvdiff against HEAD or close diff pane" })
    vim.keymap.set("n", "<leader>gs", ":G<CR>")

    local fugitive_fix_group = vim.api.nvim_create_augroup("fugitive-fix-group", { clear = true })
    -- Fugitive marks the source before :diffsplit changes its fold settings.
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = fugitive_fix_group,
      pattern = "fugitive:///*",
      callback = function(args)
        local source_winid = vim.fn.win_getid(vim.fn.winnr("#"))
        if source_winid == 0 or not vim.api.nvim_win_is_valid(source_winid) then
          return
        end

        -- Fugitive clears this flag to "", which is still truthy in Lua.
        if vim.wo[source_winid].diff or vim.w[source_winid].fugitive_diff_restore ~= 1 then
          return
        end

        if not fold_states_by_fugitive_bufnr[args.buf] then
          fold_states_by_fugitive_bufnr[args.buf] = capture_fold_state(source_winid)
        end
      end,
    })
    -- Restore source folds even when the Fugitive pane is closed without using our toggle.
    vim.api.nvim_create_autocmd("BufWinLeave", {
      group = fugitive_fix_group,
      pattern = "fugitive:///*",
      callback = function(args)
        local fold_state = fold_states_by_fugitive_bufnr[args.buf]
        fold_states_by_fugitive_bufnr[args.buf] = nil
        if fold_state then
          vim.schedule(function()
            restore_fold_state(fold_state)
          end)
        end
      end,
    })
    -- In various fugitive buffers, disable signcolumn
    vim.api.nvim_create_autocmd("User", {
      group = fugitive_fix_group,
      pattern = { "FugitiveIndex", "FugitiveEditor" },
      callback = function()
        vim.opt_local.signcolumn = "no"
      end,
    })
  end,
}
