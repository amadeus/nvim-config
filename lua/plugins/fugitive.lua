return {
  "tpope/vim-fugitive",
  version = false,
  config = function()
    vim.keymap.set("n", "<leader>gg", ":Gvdiff<CR>")
    vim.keymap.set("n", "<leader>gs", ":G<CR>")
    vim.keymap.set("n", "<leader>gd", ":silent Git difftool --staged<CR>")

    -- Dif buffers should not stick around when hidden.
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = vim.api.nvim_create_augroup("fugitivefix", { clear = true }),
      pattern = "fugitive:///*",
      callback = function()
        vim.opt_local.bufhidden = "delete"
      end,
    })

    -- In the commit buffer I don't want to see list chars
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("fugitive-gitcommit", { clear = true }),
      pattern = "gitcommit",
      callback = function()
        vim.opt_local.list = false
      end,
    })
    -- FugitiveIndex
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("fugitive-index", { clear = true }),
      pattern = "FugitiveIndex",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
      end,
    })
  end,
}
