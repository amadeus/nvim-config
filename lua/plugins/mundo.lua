return {
  "simnalamburt/vim-mundo",
  config = function()
    vim.keymap.set("n", "<leader>u", ":MundoToggle<CR>")
  end,
}
