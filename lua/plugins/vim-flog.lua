return {
  "rbong/vim-flog",
  lazy = true,
  cmd = { "Flog", "Flogsplit", "Floggit" },
  dependencies = { "tpope/vim-fugitive", version = false },
  config = function()
    vim.g.flog_default_opts = {
      date = "format:%Y-%m-%d %H:%M:%S",
    }
    -- Disable the built-in y keymaps
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("FlogCustomKeymaps", { clear = true }),
      pattern = "floggraph",
      callback = function()
        vim.keymap.set("n", "y<C-G>", "<Nop>", { buffer = true })
        vim.keymap.set("v", "y<C-G>", "<Nop>", { buffer = true })
        vim.keymap.set("n", "y<C-T>", "<Nop>", { buffer = true })
        vim.keymap.set("v", "y<C-T>", "<Nop>", { buffer = true })
        vim.keymap.set("n", "y<C-X>", "<Nop>", { buffer = true })
        vim.keymap.set("v", "y<C-X>", "<Nop>", { buffer = true })
      end,
    })
  end,
}
