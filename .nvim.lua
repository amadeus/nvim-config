vim.cmd("echom 'nvim-config .nvim.lua has been sourced'")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.g.ale_fixers = {
  lua = { "stylua" },
}

vim.g.ale_fix_on_save = 1
