return {
  "folke/lazydev.nvim",
  version = "*",
  ft = "lua",
  opts = {
    library = {
      "lazy.nvim",
      -- It can also be a table with trigger words / mods
      -- Only load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      -- always load the LazyVim library
      "LazyVim",
      -- Only load the lazyvim library when the `LazyVim` global is found
      { path = "LazyVim", words = { "LazyVim" } },
    },
  },
}
