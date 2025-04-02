return {
  "direnv/direnv.vim",
  version = false,
  init = function()
    vim.g.direnv_silent_load = 1
  end,
}
