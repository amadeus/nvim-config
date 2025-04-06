return {
  "cocopon/vaffle.vim",
  version = false,
  config = function()
    vim.keymap.set("n", "<leader>vv", ":Vaffle<CR>")
    vim.keymap.set("n", "<leader>vf", ":Vaffle %<CR>")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("vaffletab", { clear = true }),
      pattern = "vaffle",
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "<Plug>(vaffle-toggle-current)", {})
        vim.api.nvim_buf_set_keymap(0, "n", "s", "<Plug>(vaffle-open-selected-vsplit)", {})
        vim.opt_local.number = false
      end,
    })
  end,
}
