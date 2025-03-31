return {
  "rebelot/kanagawa.nvim",
  init = function() end,
  config = function()
    local kanagawa = require("kanagawa")
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
