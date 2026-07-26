return {
  "dlyongemallo/diffview-plus.nvim",
  version = false,
  keys = {
    { "<leader>dvo", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
    { "<leader>dvt", "<cmd>DiffviewToggle<cr>", desc = "Toggle Diffview" },
    { "<leader>dvc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    { "<leader>dvh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
    { "<leader>dvH", "<cmd>DiffviewFileHistory<cr>", desc = "Repository history" },
  },
}
