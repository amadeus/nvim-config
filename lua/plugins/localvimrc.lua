return {
  "embear/vim-localvimrc",
  version = false,
  init = function()
    -- This doesn't really work with lua code
    -- vim.g.localvimrc_sandbox = 1
    vim.g.localvimrc_persistent = 1
    vim.g.localvimrc_name = { ".lvimrc", ".lvimrc.lua" }
  end,
}
