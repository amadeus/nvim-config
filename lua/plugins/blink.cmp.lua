return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "folke/lazydev.nvim",
    -- {
    --   "zbirenbaum/copilot.lua",
    --   enabled = false,
    --   opts = {
    --     panel = {
    --       enabled = false,
    --     },
    --     suggestion = {
    --       enabled = false,
    --     },
    --   },
    -- },
    -- {
    --   "giuxtaposition/blink-cmp-copilot",
    --   enabled = false,
    --   dependencies = { "zbirenbaum/copilot.lua" },
    -- },
    -- "Kaiser-Yang/blink-cmp-avante",
  },
  opts = {
    keymap = {
      preset = "default",
      ["<C-n>"] = { "show", "select_next", "fallback" },
      ["<C-k>"] = { "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- Default list of enabled providers
    completion = {
      keyword = { range = "prefix" },
      list = {
        -- max_items = 1000,
        selection = {
          preselect = false,
        },
      },
      trigger = {
        prefetch_on_insert = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        -- show_on_blocked_trigger_characters = {},
        -- show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
      },
      -- A way to fix neovide cursor animations, however not currently using
      -- neovide rn...
      -- accept = {
      --   dot_repeat = false,
      -- },
      documentation = {
        auto_show = true,
        window = {
          border = { "⡏", "⠉", "⢹", "⢸", "⣸", "⣀", "⣇", "⡇" },
        },
      },
      menu = {
        border = "none",
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind", "source_id", gap = 1 },
          },
        },
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos
            return { pos[1] - 2, pos[2] }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height - 1, 0 }
        end,
      },
    },

    cmdline = {
      keymap = {
        preset = "none",
        ["<tab>"] = { "show_and_insert", "select_next" },
        ["<s-tab>"] = { "show_and_insert", "select_prev" },
        ["<c-space>"] = { "show", "fallback" },
        ["<c-n>"] = { "select_next", "fallback" },
        ["<c-p>"] = { "select_prev", "fallback" },
        ["<c-y>"] = { "select_and_accept" },
        ["<c-e>"] = { "cancel" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },

        -- Explicitly disable left/right arrow keys for completion
        ["<left>"] = { "fallback" },
        ["<right>"] = { "fallback" },
      },
      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
        menu = {
          auto_show = true,
        },
      },
    },

    sources = {
      default = {
        "lazydev",
        "lsp",
        "path",
        "buffer",
        -- "copilot",
        -- "avante",
        -- "parrot",
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        -- copilot = {
        --   name = "copilot",
        --   module = "blink-cmp-copilot",
        --   score_offset = 1,
        --   async = true,
        -- },
        -- avante = {
        --   module = "blink-cmp-avante",
        --   name = "Avante",
        --   opts = {},
        -- },
        -- parrot = {
        --   module = "parrot.completion.blink",
        --   name = "parrot",
        --   score_offset = 20,
        --   opts = {
        --     show_hidden_files = false,
        --     max_items = 50,
        --   },
        -- },
      },
      -- Appears to be broken at the moment, see: https://github.com/Saghen/blink.cmp/issues/836
      -- providers = {
      --   lsp = {
      --     override = {
      --       get_trigger_characters = function(self)
      --         local trigger_characters = self:get_trigger_characters()
      --         vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
      --         return trigger_characters
      --       end
      --     },
      --   },
      -- },
    },

    -- Experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = { "⡏", "⠉", "⢹", "⢸", "⣸", "⣀", "⣇", "⡇" },
        max_width = 1000,
        max_height = 3,
        show_documentation = false,
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
      use_frecency = true,
      use_proximity = true,
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
      -- NOTE: Remove this when I revert back to the fork
      -- prebuilt_binaries = { force_version = "v1.1.1" },
    },
  },
}
