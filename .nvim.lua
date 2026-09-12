vim.cmd("echom 'nvim-config .nvim.lua has been sourced'")

vim.g.ale_fixers = {
  lua = { "stylua" },
}

vim.g.ale_fix_on_save = 1
