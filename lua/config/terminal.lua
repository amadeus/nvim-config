-- Terminal Emulator Settings

-- Match Vim's hotkeys for popping into normal mode and using <c-w>
vim.api.nvim_set_keymap("t", "<C-w>N", "<C-\\><C-n>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>.", "<C-w>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>h", "<C-\\><C-n><C-w>h", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>j", "<C-\\><C-n><C-w>j", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>k", "<C-\\><C-n><C-w>k", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>l", "<C-\\><C-n><C-w>l", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>o", "<C-\\><C-n><C-w>o", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>=", "<C-\\><C-n><C-w>=", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-l>", "<C-\\><C-n><C-w>l", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>:", "<C-\\><C-n>:", { noremap = true })
vim.keymap.set("t", "<leader>tt", function()
  vim.cmd("stopinsert")
  require("fff").find_files()
end, { noremap = true, desc = "Open FFFile picker" })

local function terminal_window_at_bottom(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype ~= "terminal" then
    return false
  end

  local info = vim.fn.getwininfo(win)[1]
  return info and info.botline >= vim.api.nvim_buf_line_count(buf) - 20
end

local function update_terminal_follow_bottom(win)
  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype == "terminal" then
    vim.api.nvim_win_set_var(win, "terminal_follow_bottom", terminal_window_at_bottom(win))
  end
end

local function restore_terminal_bottom(win)
  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype ~= "terminal" then
    return
  end

  local ok, follow_bottom = pcall(vim.api.nvim_win_get_var, win, "terminal_follow_bottom")
  if ok and follow_bottom then
    pcall(vim.api.nvim_win_call, win, function()
      vim.cmd("normal! G")
    end)
  end
end

-- Custom terminal buffer name `[Term] [bufnbr]`
local function update_terminal_buffer_name(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "terminal" then
    return
  end
  local display_name = "[Term] " .. bufnr
  vim.api.nvim_buf_set_name(bufnr, display_name)
  -- Don't think I need this...
  -- vim.api.nvim_set_option_value("buflisted", true, { buf = bufnr })
end

-- Terminal list tweaks
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("terminal_list_tweaks", { clear = true }),
  callback = function(args)
    update_terminal_buffer_name(args.buf)
    update_terminal_follow_bottom(vim.api.nvim_get_current_win())
    vim.opt_local.list = false
    vim.opt_local.cursorline = false
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd({ "TermLeave", "CursorMoved" }, {
  group = vim.api.nvim_create_augroup("terminal_follow_bottom", { clear = true }),
  callback = function()
    update_terminal_follow_bottom(vim.api.nvim_get_current_win())
  end,
})

vim.api.nvim_create_autocmd("WinResized", {
  group = vim.api.nvim_create_augroup("terminal_resize_scrollback", { clear = true }),
  callback = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      restore_terminal_bottom(win)
    end
  end,
})

vim.api.nvim_create_autocmd("WinScrolled", {
  group = vim.api.nvim_create_augroup("terminal_scrollback", { clear = true }),
  callback = function()
    for win, change in pairs(vim.v.event) do
      if win ~= "all" and type(change) == "table" and change.width == 0 and change.height == 0 then
        local winid = tonumber(win)
        if winid then
          update_terminal_follow_bottom(winid)
        end
      end
    end
  end,
})

-- Manage cursorline in terminal buffers based on mode
vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("terminal_cursorline", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      local mode = vim.api.nvim_get_mode().mode
      if mode == "t" then
        vim.opt_local.cursorline = false
      else
        vim.opt_local.cursorline = true
      end
    end
  end,
})

local function open_split_terminal(opts, height)
  vim.cmd("botright new")
  if height then
    vim.cmd("resize " .. height)
  end

  if opts.args ~= "" then
    vim.fn.jobstart(opts.args, { term = true })
  else
    vim.cmd("terminal")
  end
end

vim.api.nvim_create_user_command("Term", function(opts)
  open_split_terminal(opts)
end, {
  nargs = "*",
  complete = "shellcmd",
  desc = "Open a terminal in a full-width bottom horizontal split",
})

vim.api.nvim_create_user_command("MiniTerm", function(opts)
  open_split_terminal(opts, 10)
end, {
  nargs = "*",
  complete = "shellcmd",
  desc = "Open a mini terminal in a small bottom horizontal split (quickfix height)",
})

return {}
