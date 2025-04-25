return {
  "olimorris/codecompanion.nvim",
  version = false,
  branch = "feat/move-to-function-calling",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    display = {
      chat = {
        show_header_separator = true,
        show_settings = true,
        show_references = true,
        show_token_count = true,
        window = {
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
              default = "gemini-2.5-pro-preview-03-25",
            },
          },
        })
      end,
    }
    require("codecompanion").setup(opts)
    vim.keymap.set({ "n", "v" }, "<leader>cf", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    -- Expand 'cc' into 'CodeCompanion' in the command line
    -- vim.cmd([[cab cc CodeCompanion]])
  end,
}
