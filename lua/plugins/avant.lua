return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "saghen/blink.cmp",
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  build = "make",
  opts = {
    -- provider = "claude",
    -- claude = {
    --   endpoint = "https://api.anthropic.com",
    --   model = "claude-3-5-sonnet-20241022",
    --   temperature = 0,
    --   max_tokens = 4096,
    -- },
  },
}
