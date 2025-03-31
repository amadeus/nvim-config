return {
  "rebelot/kanagawa.nvim",
  init = function() end,
  config = function()
    local kanagawa = require("kanagawa")
    kanagawa.setup({
      compile = false,
      theme = "wave",
      dimInactive = false,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    })
    kanagawa.load("wave")
  end,
}
