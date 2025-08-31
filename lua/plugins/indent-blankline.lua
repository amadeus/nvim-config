return {
  "lukas-reineke/indent-blankline.nvim",
  version = false,
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = "╎",
    },
    scope = {
      enabled = true,
      char = "│",
      show_start = false,
      highlight = "IblIndent",
    },
    exclude = {
      filetypes = { "startify" },
    },
  },
}
