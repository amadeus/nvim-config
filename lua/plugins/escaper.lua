return {
  "amadeus/vim-escaper",
  config = function()
    vim.g.CustomEntities = { { "(c)", "\\&copy;" } }
  end,
}
