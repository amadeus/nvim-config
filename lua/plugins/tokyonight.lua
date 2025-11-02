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
      hlgroups.DiffAdd = {
        bg = util.darken(colors.diff.add, 0.2),
      }
      hlgroups.DiffDelete = {
        fg = util.darken(colors.diff.delete, 0.5),
      }
      hlgroups["@diff.minus"] = {
        fg = colors.red,
        bg = colors.diff.delete,
      }
      hlgroups["@diff.plus"] = {
        fg = colors.green,
        bg = colors.diff.add,
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
        -- bg = util.darken(colors.terminal.yellow_bright, 0.03),
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
        fg = colors.orange,
        bg = colors.bg_dark1,
      }
      hlgroups.CursorLineSign = {
        bg = colors.bg_dark1,
      }
      hlgroups.QuickFixLine = {
        bg = hlgroups.QuickFixLine.bg,
      }
      hlgroups.Search = {
        bg = util.darken(colors.blue2, 0.1),
        fg = colors.blue5,
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
      hlgroups["@keyword.import"] = {
        fg = colors.magenta,
      }
      hlgroups["@none.tsx"] = {
        fg = colors.fg,
      }
      hlgroups["@keyword.function"] = {
        fg = util.darken(colors.blue, 0.6),
      }
      hlgroups["@number.typescript"] = {
        fg = colors.info,
      }
      hlgroups["@number.tsx"] = hlgroups["@number.typescript"]
      hlgroups["@number.css"] = hlgroups["@number.typescript"]
      hlgroups["@tag.css"] = {
        bg = util.darken(hlgroups["@tag.tsx"].fg, 0.05),
        fg = hlgroups["@tag.tsx"].fg,
      }
      hlgroups["@tag.attribute.css"] = {
        fg = colors.purple,
      }
      hlgroups["@variable.css"] = {
        fg = colors.warning,
      }
      hlgroups["@attribute.css"] = {
        fg = colors.cyan,
        bg = util.darken(colors.cyan, 0.03),
      }

      hlgroups["@markup.heading"] = {
        fg = colors.fg,
        bold = true,
      }

      hlgroups.BlinkCmpMenu = { bg = colors.bg }
      hlgroups.BlinkCmpScrollBarThumb = { bg = hlgroups.FloatBorder.fg }
      hlgroups.BlinkCmpScrollBarGutter = { bg = hlgroups.FloatBorder.fg }

      hlgroups.SnacksIndent = { fg = colors.bg_highlight }
      hlgroups.SnacksIndentScope = { fg = colors.orange }

      hlgroups.OilDirIcon = { fg = colors.blue0 }
      hlgroups.PmenuThumb = { bg = colors.bg_highlight }
      hlgroups.PmenuSel = {
        bg = util.darken(colors.bg_highlight, 0.5),
      }
      hlgroups.SnacksPickerListCursorLine = hlgroups.PmenuSel
      hlgroups.SnacksPickerDir = {
        fg = colors.fg_gutter,
      }
      hlgroups.SnacksPickerBufFlags = {
        fg = colors.bg_search,
      }
      hlgroups.SnacksPickerRow = {
        fg = colors.orange,
      }
      hlgroups.SnacksPickerDelim = {
        fg = util.darken(colors.blue, 0.5),
      }
      hlgroups.SnacksPickerRow = {
        fg = util.darken(colors.orange, 0.5),
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
