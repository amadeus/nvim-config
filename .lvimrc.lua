-- NOTE: Only source this file once per session
if vim.g.localvimrc_sourced_once == 1 then
  return
end

vim.g.localvimrc_sourced_once = 1

vim.cmd("echom 'nvim-config .lvimrc has been sourced'")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
})
