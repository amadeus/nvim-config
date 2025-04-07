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
    on_highlights = function(hl)
      hl.DiffDelete = {
        bg = "#37222c",
        fg = "#5f3138",
      }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
