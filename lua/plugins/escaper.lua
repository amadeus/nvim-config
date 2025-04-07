return {
  "amadeus/vim-escaper",
  version = false,
  cmd = { "Escape", "EscapeAll" },
  config = function()
    vim.g.CustomEntities = { { "(c)", "\\&copy;" } }
  end,
}
