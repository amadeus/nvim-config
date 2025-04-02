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
    -- This makes the window a floating thing, not sure i like it
    -- window = {
    --   -- 'float', 'right', 'left', 'bottom', or 'top'
    --   layout = "float",
    --   border = "single",
    -- },
  },
  config = function(_, opts)
    require("CopilotChat").setup(opts)
    vim.keymap.set("n", "<leader>cc", ":CopilotChat<CR>", { desc = "Open Copilot Chat" })
  end,
}
