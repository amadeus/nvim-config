return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ignore_install = {},
      modules = {},
      auto_install = true,
      sync_install = true,
      ensure_installed = {
        "c",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = {},
      },
      -- incremental_selection = {enable = true},
      textobjects = { enable = true },
      matchup = {
        enable = true,
      },
      -- autotag = {
      --   enable = true
      -- }

      -- playground = {
      --   enable = true,
      --   disable = {},
      --   updatetime = 25,
      --   persist_queries = false,
      -- }
    })
  end,
}
