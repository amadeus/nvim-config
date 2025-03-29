return {
  "mattn/vim-gist",
  cmd = "Gist",
  init = function()
    vim.g.gist_clip_command = "pbcopy"
    vim.g.gist_open_browser_after_post = 1
  end
}
