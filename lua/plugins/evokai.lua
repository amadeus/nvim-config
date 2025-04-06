return {
  "amadeus/vim-evokai",
  branch = "master",
  depth = true,
  enabled = false,
  config = function()
    vim.keymap.set("n", "<leader>mc", ":e ~/.local/share/nvim/lazy/vim-evokai/colors/evokai.vim<CR>")
    vim.keymap.set("n", "<leader>hh", ":runtime! /syntax/hitest.vim<CR>")
    vim.cmd("colorscheme evokai")
  end,
}
