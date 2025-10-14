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
      show_end = false,
    },
    exclude = {
      filetypes = { "startify", "git", "floggraph", "markdown", "diff" },
    },
  },
}
