-- Terminal Emulator Settings

-- Match Vim's hotkeys for popping into normal mode and using <c-w>
vim.api.nvim_set_keymap("t", "<C-w>N", "<C-\\><C-n>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>.", "<C-w>", { noremap = true })

-- Terminal list tweaks
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("terminal_list_tweaks", { clear = true }),
  callback = function()
    vim.cmd("startinsert")
    vim.opt_local.list = false
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

return {}
