return {
  "junegunn/goyo.vim",
  version = false,
  cmd = "Goyo",
  init = function()
    vim.g.goyo_margin_top = 5
    vim.g.goyo_margin_bottom = 5
    vim.g.goyo_width = 90
  end,
}
