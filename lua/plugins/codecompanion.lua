return {
  "amadeus/codecompanion.nvim",
  branch = "feature/buffer-auto",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  cmd = {
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionHistory",
  },
  keys = {
    {
      "<leader>cc",
      function()
        vim.cmd("CodeCompanionChat Toggle")
      end,
      mode = { "n", "v" },
      desc = "Toggle CodeCompanion Chat",
    },
    {
      "<leader>cf",
      function()
        vim.cmd("CodeCompanionActions")
      end,
      mode = { "n", "v" },
      desc = "CodeCompanion Actions",
    },
    {
      "<leader>ca",
      function()
        vim.cmd("CodeCompanionChat Add")
      end,
      mode = "v",
      desc = "Add selection to CodeCompanion Chat",
    },
    {
      "<leader>ch",
      function()
        vim.cmd("CodeCompanionHistory")
      end,
      mode = "n",
      desc = "View CodeCompanion Chat History",
    },
  },

  opts = {
    display = {
      chat = {
        show_header_separator = true,
        show_settings = false,
        show_references = true,
        show_token_count = true,
        window = {
          layout = "vertical",
          width = "auto",
          opts = {
            number = false,
            signcolumn = "no",
          },
        },
      },
      action_palette = {
        provider = "telescope",
      },
      diff = {
        close_chat_at = 240,
        layout = "vertical",
        opts = { "vertical", "internal", "filler", "closeoff", "algorithm:histogram", "linematch:120", "iwhiteall" },
      },
    },
    strategies = {
      chat = {
        keymaps = {
          send = {
            modes = { n = "<C-CR>", i = "<C-CR>" },
          },
          clear = { modes = { n = "gcr" } },
          regenerate = { modes = { n = "gcR" } },
        },
        slash_commands = {
          file = {
            opts = {
              provider = "telescope",
            },
          },
          buffer = {
            opts = {
              provider = "telescope",
            },
          },
          help = {
            opts = {
              provider = "telescope",
            },
          },
          symbols = {
            opts = {
              provider = "telescope",
            },
          },
        },
        -- adapter = "anthropic",
        -- adapter = "openai",
        adapter = "gemini",
      },
      inline = {
        -- adapter = "anthropic",
        -- adapter = "openai",
        adapter = "gemini",
      },
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          keymap = nil,
          auto_save = true,
          expiration_days = 30,
          picker = "telescope",
          continue_last_chat = true,
          delete_on_clearing_chat = false,
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        },
      },
    },
  },
  config = function(_, opts)
    opts.adapters = {
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          schema = {
            model = {
              default = "gpt-4.1",
              -- default = "gemini-2.5-pro-exp-03-25",
              -- default = "gemini-2.5-pro-preview-03-25",
            },
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          schema = {
            model = {
              -- default = "gemini-2.5-pro-exp-03-25",
              -- default = "gemini-2.5-pro-preview-03-25",
              default = "gemini-2.5-pro-preview-05-06",
            },
          },
        })
      end,
    }
    require("codecompanion").setup(opts)
  end,
}
