return {
  "mattn/vim-gist",
  version = false,
  cmd = "Gist",
  dependencies = { "mattn/webapi-vim" },
  init = function()
    vim.g.gist_clip_command = "pbcopy"
    vim.g.gist_open_browser_after_post = 1
  end,
}
