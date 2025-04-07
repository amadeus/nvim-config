return {
  "rebelot/kanagawa.nvim",
  version = false,
  enabled = false,
  init = function()
    vim.g.kanagawa_lualine_bold = true
  end,
  config = function()
    local kanagawa = require("kanagawa")
    ---@diagnostic disable-next-line: missing-fields
    kanagawa.setup({
      compile = true,
      theme = "wave",
      dimInactive = false,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        local makeDiagnosticColor = function(color)
          local c = require("kanagawa.lib.color")
          return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
        end

        return {
          DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
          DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
          DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
          DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
        }
      end,
    })
    kanagawa.load("wave")
  end,
}
