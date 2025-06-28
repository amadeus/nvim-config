return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {
      enabled = true,
      size = 0.5 * 1024 * 1024, -- 0.5mb
      notify = true,
      line_length = 1000,
    },
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },
  },
  keys = {
    {
      "<leader>sh",
      function()
        require("snacks.notifier").show_history()
      end,
      desc = "Show Notification History",
    },
  },
}
