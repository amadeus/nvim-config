return {
  "smoka7/hop.nvim",
  config = function()
    require("hop").setup({ case_insensitive = true })
    vim.keymap.set({ "n", "v" }, "<leader>kk", "<cmd>HopLine<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>jj", "<cmd>HopLine<CR>")
    vim.keymap.set({ "n", "v" }, "<space>", "<cmd>HopChar1<CR>")
  end,
}
