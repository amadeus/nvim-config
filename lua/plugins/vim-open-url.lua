return {
  "dhruvasagar/vim-open-url",
  init = function()
    vim.g.open_url_default_mappings = 0
  end,
  config = function()
    vim.keymap.set({ "n" }, "gx", "<Plug>(open-url-browser)")
    vim.keymap.set({ "x" }, "gx", "<Plug>(open-url-browser)")
  end,
}
