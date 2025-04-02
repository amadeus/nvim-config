return {
  "junegunn/fzf",
  version = false,
  enabled = false,
  build = function()
    vim.fn["fzf#install"]()
  end,
}
