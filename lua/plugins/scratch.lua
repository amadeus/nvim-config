return {
  "amadeus/scratch.vim",
  enabled = false,
  version = false,
  cmd = "Scratch",
  init = function()
    vim.g.scratch_autohide = 0
    vim.g.scratch_insert_autohide = 0
    vim.g.scratch_filetype = "markdown"
    vim.g.scratch_top = 0
  end,
}
