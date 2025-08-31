return {
  "folke/tokyonight.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  version = false,
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    lualine_bold = true,
    styles = {
      floats = "transparent",
    },
    on_colors = function(colors)
      colors.green = "#00f87b"
    end,
    on_highlights = function(hlgroups, colors)
      local util = require("tokyonight.util")
      -- local inspect_to_buffer = require("utils.inspect-to-buffer")
      -- inspect_to_buffer(hlgroups, "TokyoNight-Highlights")
      -- inspect_to_buffer(colors, "TokyoNight-Highlights")
      hlgroups["@property"] = {
        fg = colors.green,
      }
      hlgroups["@variable.member"] = {
        fg = colors.green,
      }
      hlgroups.DiffDelete = {
        fg = colors.diff.delete,
      }
      hlgroups["@markup.raw.markdown_inline"] = {
        bg = colors.bg_popup,
        fg = "#7aa2f7",
      }
      hlgroups.Folded = {
        bg = colors.bg_dark1,
        fg = hlgroups.Folded.bg,
      }
      hlgroups["@tag.tsx"] = {
        bg = util.darken(hlgroups["@tag.tsx"].fg, 0.05),
        fg = hlgroups["@tag.tsx"].fg,
      }
      hlgroups["@tag.builtin.tsx"] = {
        bg = util.darken(hlgroups["@tag.tsx"].fg, 0.05),
        fg = hlgroups["@tag.tsx"].fg,
      }
      hlgroups.String = {
        bg = util.darken(colors.orange, 0.03),
        fg = colors.orange,
      }
      hlgroups["@punctuation.special"] = {
        bg = util.darken(colors.terminal.yellow_bright, 0.03),
        fg = colors.red1,
      }
      hlgroups["LazySpecial"] = {
        fg = colors.red1,
      }
      hlgroups["@none.tsx"] = {
        bg = hlgroups.Normal.bg,
      }
      hlgroups["@punctuation.delimiter"] = {
        fg = colors.comment,
      }
      hlgroups["@punctuation.bracket"] = {
        fg = colors.comment,
      }
      hlgroups["@tag.delimiter.tsx"] = {
        fg = colors.comment,
      }
      hlgroups.Operator = {
        fg = colors.cyan,
      }
      hlgroups["@operator"] = {
        fg = colors.cyan,
      }
      hlgroups.GitSignsAdd = {
        fg = colors.terminal.green_bright,
      }
      hlgroups.GitSignsChange = {
        fg = colors.cyan,
      }
      hlgroups.GitSignsDelete = {
        fg = colors.red,
      }
      hlgroups["@markup.raw.block"] = {}
      hlgroups.VertSplit = {
        fg = colors.bg_dark1,
      }
      hlgroups.WinSeparator = {
        bold = true,
        fg = colors.bg_dark1,
      }
      hlgroups.Cursor = {
        bg = colors.orange,
        fg = colors.bg,
      }
      hlgroups.CursorLine = {
        bg = colors.bg_dark1,
      }
      hlgroups.CursorLineNr = {
        bold = true,
        fg = "#ff9e64",
        bg = colors.bg_dark1,
      }
      hlgroups.CursorLineSign = {
        bg = colors.bg_dark1,
      }
      hlgroups.QuickFixLine = {
        bg = hlgroups.QuickFixLine.bg,
      }
      hlgroups.IncSearch = {
        bg = util.darken(hlgroups.IncSearch.bg, 0.3),
        fg = hlgroups.IncSearch.bg,
      }
      hlgroups.OffscreenPopup = {
        bg = util.darken(colors.orange, 0.05),
        fg = colors.orange,
      }
      hlgroups.NonText = { fg = colors.bg_highlight }
      hlgroups.Whitespace = { fg = colors.bg_highlight }
      hlgroups.AvanteSidebarWinSeparator = {
        bold = true,
        fg = colors.bg_dark1,
      }
      hlgroups.FloatBorder = {
        bg = colors.bg_float,
        fg = colors.fg_gutter,
      }
      -- Get rid of the hideous darker bg color in Neotree
      hlgroups.NeoTreeNormal = {
        bg = colors.bg,
        fg = colors.fg,
      }
      hlgroups.NeoTreeNormalNC = {
        bg = colors.bg,
        fg = colors.fg,
      }
      hlgroups.NeoTreeIndentMarker = {
        fg = colors.bg_highlight,
      }

      hlgroups.BlinkCmpMenu = { bg = colors.bg_dark }
      hlgroups.BlinkCmpMenuBorder = hlgroups.BlinkCmpMenu
      hlgroups.BlinkCmpDocBorder = hlgroups.FloatBorder
      hlgroups.BlinkCmpSignatureHelpBorder = hlgroups.FloatBorder
      hlgroups.BlinkCmpScrollBarThumb = { bg = colors.bg_highlight }
      hlgroups.BlinkCmpScrollBarGutter = { bg = colors.bg_dark }

      hlgroups.IblIndent = { fg = colors.bg_highlight }
      hlgroups.IblScope = { fg = colors.orange }

      hlgroups.TelescopeBorder = hlgroups.FloatBorder
      hlgroups.TelescopePromptBorder = hlgroups.FloatBorder
      hlgroups.OilDirIcon = { fg = colors.blue0 }
      hlgroups.Pmenu = {
        bg = "#ff0000",
      }
      hlgroups.PmenuSbar = hlgroups.FloatBorder
      hlgroups.PmenuThumb = {
        bg = colors.bg_highlight,
      }
      -- Appears to be the only way I can properly override the default icon
      -- color... which seems to be inherited everywhere...
      require("nvim-web-devicons").set_default_icon("", colors.terminal.black_bright, 65)
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
    vim.keymap.set("n", "<leader>mc", ":e ~/.local/share/nvim/lazy/nvim-config/lua/plugins/tokyonight.lua<CR>")
  end,
}
