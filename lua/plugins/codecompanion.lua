return {
  "olimorris/codecompanion.nvim",
  -- Potential override if i need to make tweaks...
  -- url = "https://github.com/amadeus/codecompanion.nvim",
  -- branch = "chat-bd-fix",
  version = false,
  dependencies = {
    { "nvim-lua/plenary.nvim", version = false },
    { "nvim-treesitter/nvim-treesitter", version = false },
    { "ravitemer/codecompanion-history.nvim", version = false },
    -- Seems busted at the moment, unfort...
    -- "minusfive/codecompanion-agent-rules",
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
        vim.cmd("Telescope codecompanion theme=dropdown")
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
        intro_message = " Ready for Advanced Topics",
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
        layout = "split",
        opts = { "internal", "filler", "closeoff", "algorithm:histogram", "linematch:120", "iwhiteall" },
      },
    },
    strategies = {
      chat = {
        roles = {
          ---@type string|fun(adapter: CodeCompanion.Adapter): string
          llm = function(adapter)
            return "Dis Bisch ( " .. adapter.model.name .. ")"
          end,
          user = "Sum Bisch",
        },
        keymaps = {
          send = { modes = { n = "<C-CR>" } },
          clear = { modes = { n = "gcr" } },
          regenerate = { modes = { n = "gcR" } },
          stop = { modes = { n = "<C-q>" } },
          options = { modes = { n = "gc?" } },
        },
        slash_commands = {
          file = { opts = { provider = "telescope" } },
          buffer = { opts = { provider = "telescope" } },
          help = { opts = { provider = "telescope" } },
          symbols = { opts = { provider = "telescope" } },
        },
        -- adapter = "gemini",
        adapter = "anthropic",
        tools = {
          opts = {
            -- Pretty sure these already default to being on, but just to be
            -- safe...
            auto_submit_errors = true,
            auto_submit_success = true,
            -- Lets wait 30 minutes for user interaction... ideally this would
            -- never trigger, but there must be some reason for this
            -- wait_timeout, but i'd like to not feel rushed and review things
            -- before accepting generally...
            wait_timeout = 1000 * 60 * 30,
          },
        },
      },
      inline = {
        adapter = "gemini",
        keymaps = {
          accept_change = {
            modes = { n = "gA" },
          },
          reject_change = {
            modes = { n = "gR" },
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

          summary = {
            create_summary_keymap = "gcs",
            browse_summaries_keymap = "<leader>cbs",
            preview_summary_keymap = "<leader>cps",
          },
        },
      },
      -- vectorcode = {
      --   ---@type VectorCode.CodeCompanion.ExtensionOpts
      --   opts = {
      --     tool_group = {
      --       -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
      --       enabled = true,
      --       -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
      --       -- if you use @vectorcode_vectorise, it'll be very handy to include
      --       -- `file_search` here.
      --       extras = {},
      --       collapse = false, -- whether the individual tools should be shown in the chat
      --     },
      --     tool_opts = {
      --       ---@type VectorCode.CodeCompanion.LsToolOpts
      --       ls = {},
      --       ---@type VectorCode.CodeCompanion.VectoriseToolOpts
      --       vectorise = {},
      --       ---@type VectorCode.CodeCompanion.QueryToolOpts
      --       query = {
      --         max_num = { chunk = -1, document = -1 },
      --         default_num = { chunk = 50, document = 10 },
      --         include_stderr = false,
      --         use_lsp = false,
      --         no_duplicate = true,
      --         chunk_mode = false,
      --         ---@type VectorCode.CodeCompanion.SummariseOpts
      --         summarise = {
      --           ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
      --           enabled = false,
      --           adapter = nil,
      --           query_augmented = true,
      --         },
      --       },
      --     },
      --   },
      -- },
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
    -- Make 2.5 pro the default, too many problems with flash...
    opts.adapters = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          schema = {
            model = {
              default = "gemini-2.5-pro",
            },
          },
        })
      end,
    }
    require("codecompanion").setup(opts)
  end,
}
