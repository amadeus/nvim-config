return {
  "mattn/vim-gist",
  cmd = "Gist",
  config = function()
    vim.g.gist_clip_command = "pbcopy"
    vim.g.gist_open_browser_after_post = 1
  end
}
