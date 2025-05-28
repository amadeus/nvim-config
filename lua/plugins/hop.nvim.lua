return {
  "smoka7/hop.nvim",
  version = false,
  opts = {
    case_insensitive = true,
    virtual_cursor = true,
  },
  config = function(_, opts)
    require("hop").setup(opts)
    vim.keymap.set({ "n", "v" }, "<leader>kk", "<cmd>HopLine<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>jj", "<cmd>HopLine<CR>")
    vim.keymap.set({ "n", "v" }, "<space>", "<cmd>HopChar1<CR>")
  end,
}
