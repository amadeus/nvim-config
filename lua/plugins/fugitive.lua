return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gg", ":Gvdiff<CR>")
    vim.keymap.set("n", "<leader>gs", ":G<CR>")
    vim.keymap.set("n", "<leader>gc", ":Gcommit -v<CR>")
    vim.keymap.set("n", "<leader>gd", ":silent Git difftool --staged<CR>")

    vim.api.nvim_create_autocmd("BufReadPost", {
      group = vim.api.nvim_create_augroup("fugitivefix", { clear = true }),
      pattern = "fugitive:///*",
      callback = function()
        vim.opt_local.bufhidden = "delete"
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("gitcommit", { clear = true }),
      pattern = "gitcommit",
      callback = function()
        vim.opt_local.list = false
      end,
    })
  end,
}
