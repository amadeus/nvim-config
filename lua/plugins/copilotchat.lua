return {
  "CopilotC-Nvim/CopilotChat.nvim",
  version = false,
  enabled = false,
  dependencies = {
    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  opts = {},
}
