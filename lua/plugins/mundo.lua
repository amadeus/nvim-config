return {
  "simnalamburt/vim-mundo",
  version = false,
  config = function()
    vim.keymap.set("n", "<leader>u", ":MundoToggle<CR>")
  end,
}
