return {
  "simnalamburt/vim-mundo",
  version = false,
  lazy = true,
  cmd = "MundoToggle",
  keys = {
    { "<leader>u", "<cmd>MundoToggle<CR>", desc = "Toggle Mundo" },
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("mundo-ui", { clear = true }),
      pattern = { "Mundo", "MundoDiff" },
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
      end,
      desc = "Disable UI elements in Mundo windows",
    })
  end,
}
