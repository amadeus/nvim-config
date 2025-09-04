-- Terminal Emulator Settings

-- Match Vim's hotkeys for popping into normal mode and using <c-w>
vim.api.nvim_set_keymap("t", "<C-w>N", "<C-\\><C-n>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>.", "<C-w>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>h", "<C-\\><C-n><C-w>h", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>j", "<C-\\><C-n><C-w>j", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>k", "<C-\\><C-n><C-w>k", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>l", "<C-\\><C-n><C-w>l", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w><C-l>", "<C-\\><C-n><C-w>l", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>:", "<C-\\><C-n>:", { noremap = true })

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
    vim.opt_local.list = false
    vim.opt_local.cursorline = false
    vim.cmd("startinsert")
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

vim.api.nvim_create_user_command("Term", function(opts)
  -- opts.fargs is a list containing one string with all arguments when nargs = '*'
  local args_string = table.concat(opts.fargs, " ")
  vim.cmd("botright term " .. args_string)
end, {
  nargs = "*",
  complete = "shellcmd",
  desc = "Open a terminal in a full-width bottom horizontal split",
})

vim.api.nvim_create_user_command("MiniTerm", function(opts)
  local args_string = table.concat(opts.fargs, " ")
  vim.cmd("botright term " .. args_string)
  vim.cmd("resize 10")
end, {
  nargs = "*",
  complete = "shellcmd",
  desc = "Open a mini terminal in a small bottom horizontal split (quickfix height)",
})

return {}
