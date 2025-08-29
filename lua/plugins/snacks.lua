return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@class snacks.scratch.Config
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
    scratch = {
      title = "Scratch",
      ft = "markdown",
      filekey = {
        cwd = true,
        branch = false,
        count = false,
      },
    },
    styles = {
      notification_history = {
        border = "solid",
      },
      scratch = {
        border = "solid",
        minimal = true,
      },
    },
  },
  keys = {
    {
      "<leader>nh",
      function()
        require("snacks.notifier").show_history()
      end,
      desc = "Show Notification History",
    },
    {
      "<leader>sb",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>sB",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
  },
}
