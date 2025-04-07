return {
  "folke/tokyonight.nvim",
  version = false,
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    lualine_bold = true,
    styles = {
      floats = "transparent",
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
