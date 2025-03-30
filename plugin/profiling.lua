local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>DD", function()
  vim.cmd("profile start profile.log")
  vim.cmd("profile func *")
  vim.cmd("profile file *")
end, opts)

vim.keymap.set("n", "<leader>DP", function()
  vim.cmd("profile pause")
end, opts)

vim.keymap.set("n", "<leader>DC", function()
  vim.cmd("profile continue")
end, opts)

vim.keymap.set("n", "<leader>DQ", function()
  vim.cmd("profile pause")
  vim.cmd("noautocmd qall!")
end, opts)
