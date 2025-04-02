return {
  "airblade/vim-gitgutter",
  version = false,
  enabled = false,
  init = function()
    vim.g.gitgutter_async = 1
    vim.g.gitgutter_eager = 1
    vim.g.gitgutter_realtime = 1
    vim.g.gitgutter_map_keys = 0
  end,
  config = function()
    vim.keymap.set("n", "<D-j>", "<Plug>(GitGutterNextHunk)", { silent = true })
    vim.keymap.set("n", "<D-k>", "<Plug>(GitGutterPrevHunk)", { silent = true })
    vim.keymap.set("n", "<leader>sh", "<Plug>(GitGutterStageHunk)", { silent = true })
    vim.keymap.set("n", "<leader>rh", "<Plug>(GitGutterRevertHunk)", { silent = true })
    vim.keymap.set("n", "<leader>ga", "<Plug>(GitGutterAll)", { silent = true })
  end,
}
