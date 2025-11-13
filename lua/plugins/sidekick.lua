return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      win = {
        -- Allow the terminal split to act like a normie vim buffer
        wo = { winfixwidth = false },
        split = { width = 0, height = 0 },
      },
    },
  },
  keys = {
    {
      "<leader>ss",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>sp",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>st",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
  },
}
