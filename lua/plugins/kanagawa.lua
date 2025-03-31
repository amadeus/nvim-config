return {
  "rebelot/kanagawa.nvim",
  init = function() end,
  config = function()
    local kanagawa = require("kanagawa")
    kanagawa.setup({
      compile = false,
      theme = "wave",
      dimInactive = false,
    })
    kanagawa.load("wave")
  end,
}
