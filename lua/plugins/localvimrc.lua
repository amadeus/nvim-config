return {
  "embear/vim-localvimrc",
  version = false,
  init = function()
    vim.g.localvimrc_sandbox = 0
    vim.g.localvimrc_persistent = 1
    vim.g.localvimrc_name = { ".lvimrc", ".lvimrc.lua" }
  end,
}
