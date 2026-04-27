return {
  "embear/vim-localvimrc",
  version = false,
  init = function()
    -- Sandboxing doesn't really work with lua code
    vim.g.localvimrc_sandbox = 0
    vim.g.localvimrc_persistent = 1
    vim.g.localvimrc_name = { ".lvimrc", ".lvimrc.lua" }
  end,
}
