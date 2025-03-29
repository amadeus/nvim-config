return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = { "folke/lazydev.nvim" },
  config = function()
    local blink_cmp = require('blink.cmp')
    -- Configure blink.cmp
    blink_cmp.setup({
      keymap = {
        preset = 'default',
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },
        ['<C-k>'] = { 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- Default list of enabled providers
      completion = {
        list = {
          selection = {
            preselect = false,
          }
        },
        trigger = {
          show_on_keyword = true,
          show_on_trigger_character = true;
          show_on_blocked_trigger_characters = {},
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
              { 'label', 'label_description', gap = 1 },
              { 'kind', 'source_id', gap = 1 },
            },
          },
        },
      },

      cmdline = {
        -- This seems to build grepper for some reason :thonk:
        -- enabled = false,
        keymap = {
          preset = 'cmdline',
          ['<tab>'] = { 'select_and_accept' },
          ['<left>'] = { 'fallback' },
          ['<right>'] = { 'fallback' },
        },
        -- Doesn't appear to do anything...
        -- sources = function()
        --   local type = vim.fn.getcmdtype()
        --   -- Search forward and backward
        --   if type == '/' or type == '?' then return { 'buffer' } end
        --   -- Commands
        --   if type == ':' or type == '@' then return { 'cmdline' } end
        --   return {}
        -- end,
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
        default = { 'lazydev', 'lsp', 'path', 'buffer' },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100
          }
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
          border = 'none',
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" }
    })
  end
}
