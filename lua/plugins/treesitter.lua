return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
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
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<leader><leader>i",
          node_incremental = "<leader>l",
          node_decremental = "<leader>h",
        },
      },
      textobjects = {
        enable = true,
      },
      matchup = {
        enable = true,
      },
      fold = {
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
    vim.opt.foldlevel = 99
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
}
