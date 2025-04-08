return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "folke/lazydev.nvim",
    {
      "zbirenbaum/copilot.lua",
      opts = {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = false,
        },
      },
    },
    {
      "giuxtaposition/blink-cmp-copilot",
      dependencies = { "zbirenbaum/copilot.lua" },
    },
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
      list = {
        selection = {
          preselect = false,
        },
      },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
        -- show_on_blocked_trigger_characters = {},
        -- show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
      },
      accept = {
        -- A way to fix neovide cursor animations
        dot_repeat = false,
      },
      documentation = {
        auto_show = true,
      },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind", "source_id", gap = 1 },
          },
        },
      },
    },

    cmdline = {
      -- This seems to build grepper for some reason :thonk:
      -- enabled = false,
      keymap = {
        preset = "cmdline",
        -- I don't think I actually want this tab action here anymore...
        -- ["<tab>"] = { "select_and_accept" },
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
      default = { "lazydev", "lsp", "path", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 1,
          async = true,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
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
        border = "rounded",
        max_width = 100,
        max_height = 3,
        show_documentation = false,
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
    },
  },
}
