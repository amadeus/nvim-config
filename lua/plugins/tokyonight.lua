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
        fg = colors.fg,
      }
      hlgroups["@variable.member"] = {
        fg = colors.fg,
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
      -- NOTE: These colors are from my old Evokai config...
      hlgroups["@tag.tsx"] = {
        bg = "#003e65",
        fg = "#36a6ff",
      }
      hlgroups["@tag.builtin.tsx"] = {
        bg = "#003e65",
        fg = "#36a6ff",
      }
      hlgroups["@tag.attribute.tsx"] = {
        fg = colors.green1,
      }
      hlgroups.String = {
        bg = util.darken("#fed944", 0.05),
        fg = "#fed944",
      }
      hlgroups["@punctuation.special"] = {
        bg = util.darken(colors.red1, 0.05),
        fg = colors.red1,
      }
      hlgroups["@none.tsx"] = {
        bg = hlgroups.Normal.bg,
      }
      hlgroups["@punctuation.delimiter"] = {
        fg = colors.comment,
      }
      hlgroups["@punctuation.bracket"] = {
        fg = colors.purple,
      }
      hlgroups["@tag.delimiter.tsx"] = {
        fg = colors.comment,
      }
      hlgroups.Operator = {
        fg = colors.red1,
      }
      hlgroups["@operator"] = {
        fg = colors.red1,
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
        fg = colors.bg,
        bg = colors.orange,
      }
      hlgroups["@number"] = {
        fg = colors.magenta,
      }
      hlgroups["@type.builtin"] = {
        fg = colors.blue0,
      }
      hlgroups["@boolean"] = {
        fg = colors.blue1,
      }
      hlgroups["@type.typescript"] = {}
      hlgroups["@lsp.type.type"] = {
        fg = colors.dark5,
      }
      hlgroups["@lsp.type.interface"] = {
        fg = colors.dark5,
      }
      hlgroups["@lsp.type.namespace"] = {
        fg = colors.dark5,
      }
      hlgroups["@lsp.typemod.interface"] = {
        fg = colors.green,
      }
      hlgroups["@type.tsx"] = {}
      hlgroups["@keyword.conditional"] = {
        fg = colors.red,
      }
      hlgroups["@keyword.return"] = {
        fg = colors.red,
        gui = nil,
      }
      hlgroups["@variable.parameter"] = {
        fg = colors.orange,
      }
      hlgroups["@constant"] = {
        fg = colors.green,
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
