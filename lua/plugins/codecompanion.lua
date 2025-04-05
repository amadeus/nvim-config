return {
  "olimorris/codecompanion.nvim",
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
        opts = { "vertical", "internal", "filler", "closeoff", "algorithm:histogram", "linematch:120" },
      },
    },
    strategies = {
      chat = {
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
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
    vim.keymap.set({ "n", "v" }, "<leader>cf", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    -- Expand 'cc' into 'CodeCompanion' in the command line
    -- vim.cmd([[cab cc CodeCompanion]])
  end,
}
