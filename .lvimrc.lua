-- NOTE: Only source this file once per session
if vim.g.localvimrc_sourced_once == 1 then
  return
end

vim.g.localvimrc_sourced_once = 1

vim.cmd("echom 'nvim-config .lvimrc has been sourced'")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.g.ale_fixers = {
  lua = { "stylua" },
}

vim.g.ale_fix_on_save = 1
