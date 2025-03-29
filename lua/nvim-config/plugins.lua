return {
  { "nvim-lualine/lualine.nvim" },
  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },
  -- "easymotion/vim-easymotion" (commented out in original)
  { "smoka7/hop.nvim" }, -- Alternative to easy-motion that won't break buffer linting
  { "mhinz/vim-grepper" },
  { "embear/vim-localvimrc" },
  { "mhinz/vim-startify" },
  -- "andymass/vim-matchup" (commented out in original)
  { "RRethy/vim-hexokinase", build = "make hexokinase" },
  { "simnalamburt/vim-mundo" },
  { "junegunn/goyo.vim", cmd = "Goyo" },
  { "junegunn/gv.vim", cmd = "GV" },
  { "Raimondi/delimitMate" },
  { "wellle/targets.vim" },
  { "mattn/webapi-vim" },
  { "mattn/vim-gist", cmd = "Gist" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-surround" },
  { "tpope/vim-unimpaired" },
  { "tpope/vim-repeat" },
  { "tpope/vim-obsession" },
  { "tpope/vim-abolish" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-apathy" },
  { "roryokane/detectindent" },
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end
  },
  { "junegunn/fzf.vim" },
  { "cocopon/vaffle.vim" },

  -- LSP Stuff
  { "nvim-lua/plenary.nvim" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "stevearc/conform.nvim" },

  -- Linting & Stuff
  { "dense-analysis/ale" },
  -- "nvimtools/none-ls.nvim" (commented out in original)

  -- Treesitter stuff
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  -- "m-demare/hlargs.nvim" (commented out in original)
  -- "nvim-treesitter/playground" (commented out in original)

  -- Testing blink.cmp
  { "nvim-tree/nvim-web-devicons" },
  { "saghen/blink.cmp", version = "*" },
  -- "rafamadriz/friendly-snippets" (commented out in original)

  -- Misc Stuff
  { "sbdchd/neoformat" },
  { "dhruvasagar/vim-open-url" },
  -- "romainl/vim-cool" (commented out with note that it causes issues with Claude Chat)
  { "amadeus/vim-px-to-em" },
  { "amadeus/scratch.vim" },
  { "amadeus/vim-convert-color-to" },
  { "amadeus/vim-escaper" },
  { "amadeus/vim-evokai" },
  { "Shatur/neovim-ayu" },
  { "amadeus/vim-misc" },
  { "pasky/claude.vim" },
}
