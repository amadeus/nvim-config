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
      win = {
        keys = {
          q = false,
          gq = "close",
        },
      },
    },
    picker = {
      ui_select = true,
      formatters = {
        file = {
          filename_first = true,
        },
      },
      win = {
        input = {
          keys = {
            -- Ensure that escape allows us to quit the picker
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
      layout = {
        preset = "dropdown",
        layout = {
          backdrop = false,
          width = 0.4,
          min_width = 80,
          height = 0.25,
          min_height = 10,
          border = "none",
          box = "vertical",
          {
            box = "vertical",
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
        },
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
    -- Picker maps
    {
      "<leader>b",
      function()
        Snacks.picker.buffers({
          win = {
            input = {
              keys = {
                ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
              },
            },
          },
        })
      end,
      desc = "Buffers",
    },
    {
      "<leader>tb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>th",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>jd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "<leader>ji",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "<leader>fsh",
      function()
        Snacks.picker.highlights({ pattern = "hl_group:^Snacks" })
      end,
      nowait = true,
      desc = "Snacks Highlights",
    },
  },
}
