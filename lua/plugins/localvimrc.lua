return {
  "embear/vim-localvimrc",
  init = function()
    vim.g.localvimrc_sandbox = 0
    vim.g.localvimrc_persistent = 1
  end,
}
