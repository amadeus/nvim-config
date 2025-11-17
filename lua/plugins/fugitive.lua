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
          -- Return fugitive window ID and buffer number
          return winid, win_bufnr
        end
      end
    end
  end
  return nil, nil
end

local function SmartGvdiffToggle()
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
      local fugitive_winid_to_close, _ = find_fugitive_diff_window(current_bufnr)
      if fugitive_winid_to_close then
        if vim.api.nvim_win_is_valid(fugitive_winid_to_close) then
          vim.api.nvim_win_close(fugitive_winid_to_close, false)
        end
      end
    end
  else
    -- We are not in a diff window, initialize diff view and move cursor to
    -- source buffer
    vim.cmd("Gvdiff")
    vim.cmd("wincmd l")
  end
end

return {
  "tpope/vim-fugitive",
  version = false,
  config = function()
    vim.keymap.set("n", "<leader>gg", SmartGvdiffToggle, { desc = "Open Gvdiff or close diff pane" })
    vim.keymap.set("n", "<leader>gs", ":G<CR>")

    local fugitive_fix_group = vim.api.nvim_create_augroup("fugitive-fix-group", { clear = true })
    -- Diff buffers should not stick around when hidden
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = fugitive_fix_group,
      pattern = "fugitive:///*",
      callback = function()
        vim.opt_local.bufhidden = "delete"
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
