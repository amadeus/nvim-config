return {
  "amadeus/vim-evokai",
  config = function()
    vim.keymap.set("n", "<leader>mc", ":e ~/.config/nvim/colors/evokai.lua<CR>")
    vim.keymap.set("n", "<leader>hh", ":runtime! /syntax/hitest.vim<CR>")
  end,
}
