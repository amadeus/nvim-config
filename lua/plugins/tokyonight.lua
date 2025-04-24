return {
  "folke/tokyonight.nvim",
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
      -- local inspect_utils = require("utils.inspect-to-buffer")
      -- inspect_utils.inspect_to_buffer(c, "TokyoNight-Highlights")
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
        fg = hlgroups.Folded.fg,
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
        -- bg = "#292e42",
        bg = colors.bg_dark1,
      }
      hlgroups.CursorLineNr = {
        bold = true,
        -- fg = "#ff9e64",
        fg = colors.bg,
        bg = colors.orange,
      }
      hlgroups.QuickFixLine = {
        bg = hlgroups.QuickFixLine.bg,
      }
      hlgroups.IncSearch = {
        bg = util.darken(hlgroups.IncSearch.bg, 0.3),
        fg = hlgroups.IncSearch.bg,
      }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
    vim.keymap.set("n", "<leader>mc", ":e ~/.local/share/nvim/lazy/nvim-config/lua/plugins/tokyonight.lua<CR>")
  end,
}
