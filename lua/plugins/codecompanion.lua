return {
  "olimorris/codecompanion.nvim",
  version = false,
  dependencies = {
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
        opts = { "internal", "filler", "closeoff", "algorithm:histogram", "linematch:120", "iwhiteall" },
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
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
        keymaps = {
          accept_change = {
            modes = { n = "gca" },
          },
          reject_change = {
            modes = { n = "gcr" },
          },
        },
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
      -- mcphub = {
      --   callback = "mcphub.extensions.codecompanion",
      --   opts = {
      --     show_results_in_chat = true,
      --     make_vars = true,
      --     make_slash_commands = true,
      --   },
      -- },
    },
  },
  config = function(_, opts)
    opts.adapters = {
      gemini = function()
        local deep_copy = require("utils.deep_copy")
        local gemini_adapter = require("codecompanion.adapters.gemini")
        local my_gemini_adapter = deep_copy(gemini_adapter)
        -- NOTE: Just a temporary thing until it gets added officially...
        my_gemini_adapter.schema.model.choices["gemini-2.5-pro"] = {
          opts = { can_reason = true, has_vision = true },
        }
        my_gemini_adapter.schema.model.default = "gemini-2.5-pro"
        return my_gemini_adapter
      end,
    }
    require("codecompanion").setup(opts)
  end,
}
