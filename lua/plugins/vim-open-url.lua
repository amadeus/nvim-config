return {
  "dhruvasagar/vim-open-url",
  config = function()
    vim.g.open_url_default_mappings = 0
    vim.keymap.set({"n"}, "gx", "<Plug>(open-url-browser)")
    vim.keymap.set({"x"}, "gx", "<Plug>(open-url-browser)")
  end
}
