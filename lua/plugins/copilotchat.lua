return {
  "CopilotC-Nvim/CopilotChat.nvim",
  version = false,
  dependencies = {
    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  opts = {
    model = {
      provider = "anthropic",
      -- Claude 3 Sonnet model
      name = "claude-3-sonnet-20240229",
    },
    debug = false, -- Set to true to see API request logs
    show_user_selection = true,
    window = {
      -- Note sure what this is for yet...
      -- 'float', 'right', 'left', 'bottom', or 'top'
      layout = "float",
      border = "single",
    },
  },
  config = function(_, opts)
    require("copilot.chat").setup(opts)
    vim.keymap.set("n", "<leader>cc", function()
      require("copilot.chat").open()
    end, { desc = "Open Copilot Chat" })
  end,
}
