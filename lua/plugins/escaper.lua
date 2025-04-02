return {
  "amadeus/vim-escaper",
  version = false,
  config = function()
    vim.g.CustomEntities = { { "(c)", "\\&copy;" } }
  end,
}
