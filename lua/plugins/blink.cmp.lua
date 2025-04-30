return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "folke/lazydev.nvim",
    {
      "zbirenbaum/copilot.lua",
      enabled = false,
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
      enabled = false,
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
      keyword = { range = "full" },
      list = {
        max_items = 1000,
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
      },
      menu = {
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
      default = {
        "lazydev",
        "lsp",
        "path",
        "buffer", --[[ "copilot" ]]
      },
      providers = {
        -- copilot = {
        --   name = "copilot",
        --   module = "blink-cmp-copilot",
        --   score_offset = 1,
        --   async = true,
        -- },
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
    },
  },
}
