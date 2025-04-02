return {
  "dhruvasagar/vim-open-url",
  -- NOTE: Figure out a neovim version of this...
  version = false,
  init = function()
    vim.g.open_url_default_mappings = 0
  end,
  config = function()
    vim.keymap.set({ "n" }, "gx", "<Plug>(open-url-browser)")
    vim.keymap.set({ "x" }, "gx", "<Plug>(open-url-browser)")
  end,
}
