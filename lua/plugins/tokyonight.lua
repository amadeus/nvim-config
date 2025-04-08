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
    on_highlights = function(hl, c)
      local util = require("tokyonight.util")
      -- local inspect_utils = require("utils.inspect-to-buffer")
      -- inspect_utils.inspect_to_buffer(c, "TokyoNight-Highlights")
      hl.DiffDelete = {
        fg = c.diff.delete,
      }
      hl["@markup.raw.markdown_inline"] = {
        bg = c.bg_popup,
        fg = "#7aa2f7",
      }
      hl.Folded = {
        bg = c.bg_dark1,
        fg = hl.Folded.fg,
      }
      hl["@tag.tsx"] = {
        bg = util.darken(hl["@tag.tsx"].fg, 0.05),
        fg = hl["@tag.tsx"].fg,
      }
      hl["@tag.builtin.tsx"] = {
        bg = util.darken(hl["@tag.tsx"].fg, 0.05),
        fg = hl["@tag.tsx"].fg,
      }
      hl.String = {
        bg = util.darken(c.orange, 0.03),
        fg = c.orange,
      }
      hl["@punctuation.special"] = {
        bg = util.darken(c.terminal.yellow_bright, 0.03),
        fg = c.red1,
      }
      hl["@none.tsx"] = {
        bg = hl.Normal.bg,
      }
      hl["@punctuation.delimiter"] = {
        fg = c.comment,
      }
      hl["@punctuation.bracket"] = {
        fg = c.comment,
      }
      hl["@tag.delimiter.tsx"] = {
        fg = c.comment,
      }
      hl.Operator = {
        fg = c.cyan,
      }
      hl["@operator"] = {
        fg = c.cyan,
      }
      hl.GitSignsAdd = {
        fg = c.terminal.green_bright,
      }
      hl.GitSignsChange = {
        fg = c.cyan,
      }
      hl.GitSignsDelete = {
        fg = c.red,
      }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd([[colorscheme tokyonight-night]])
    vim.keymap.set("n", "<leader>mc", ":e ~/.local/share/nvim/lazy/nvim-config/lua/plugins/tokyonight.lua<CR>")
  end,
}
