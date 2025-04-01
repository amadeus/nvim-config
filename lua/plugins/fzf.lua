return {
  "junegunn/fzf",
  enabled = false,
  build = function()
    vim.fn["fzf#install"]()
  end,
}
