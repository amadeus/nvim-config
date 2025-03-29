return {
  "cocopon/vaffle.vim",
  config = function()
    vim.keymap.set("n", "<leader>vv", ":Vaffle<CR>")
    vim.keymap.set("n", "<leader>vf", ":Vaffle %<CR>")

    vim.api.nvim_create_augroup("vaffletab", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = "vaffletab",
      pattern = "vaffle",
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "<Plug>(vaffle-toggle-current)", {})
        vim.api.nvim_buf_set_keymap(0, "n", "s", "<Plug>(vaffle-open-selected-vsplit)", {})
      end,
    })
  end
}
