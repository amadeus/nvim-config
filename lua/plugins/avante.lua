return {
  "yetone/avante.nvim",
  version = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "saghen/blink.cmp",
    "nvim-telescope/telescope.nvim",
  },
  build = "make",
  opts = {
    provider = "gemini",
    gemini = {
      model = "gemini-2.5-pro-preview-05-06",
    },
    windows = {
      width = nil,
      sidebar_header = {
        enabled = false,
      },
    },
    selector = {
      provider = "telescope",
    },
    file_selector = {
      provider = "telescope",
    },
    -- provider = "claude",
    -- claude = {
    --   model = "claude-3-5-sonnet-20241022",
    -- },
  },
}
