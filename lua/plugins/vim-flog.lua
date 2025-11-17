return {
  "rbong/vim-flog",
  lazy = true,
  cmd = { "Flog", "Flogsplit", "Floggit" },
  dependencies = { "tpope/vim-fugitive", version = false },
  config = function()
    vim.g.flog_default_opts = {
      date = "format:%Y-%m-%d %H:%M:%S",
    }
  end,
}
