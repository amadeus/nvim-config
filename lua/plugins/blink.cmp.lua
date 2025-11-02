return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = { "folke/lazydev.nvim", "nvim-web-devicons" },
  opts = {
    keymap = {
      preset = "default",
      ["<C-n>"] = { "show", "select_next", "fallback" },
      ["<C-k>"] = { "fallback" },
      ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
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
          border = "rounded",
        },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon", "label", "label_description", gap = 1 },
            { "kind", "source_id", gap = 1 },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                -- Use file-specific icons for path completions
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                end
                return icon .. ctx.icon_gap
              end,
              -- Use color highlights from nvim-web-devicons for path completions
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local _, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_hl then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
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
      -- NOTE: Remove this when I revert back to the fork
      -- prebuilt_binaries = { force_version = "v1.1.1" },
    },
  },
}
