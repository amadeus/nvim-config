return {
  "Shatur/neovim-ayu",
  enabled = false,
  config = function()
    require('ayu').setup({
      mirage = true,
      overrides = {
        Normal = { bg = "None" },
        -- CursorColumn = { bg = "None" },
        -- CursorLine = { style = '' },
        SignColumn = { bg = "None" },
        EndOfBuffer = { fg = "#0f1419" },
      }
    })
  end
}
