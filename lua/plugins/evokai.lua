return {
  "amadeus/vim-evokai",
  config = function()
    vim.keymap.set("n", "<leader>mc", ":e ~/.local/share/nvim/lazy/vim-evokai/colors/evokai.vim<CR>")
    vim.keymap.set("n", "<leader>hh", ":runtime! /syntax/hitest.vim<CR>")
  end,
}
