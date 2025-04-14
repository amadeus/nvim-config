return {
  "yetone/avante.nvim",
  version = false,
  -- Need to think about this one a bit more, it's kinda heavy and takes shit
  -- over... in like _not_ a good way
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "saghen/blink.cmp",
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  build = "make",
  opts = {
    -- provider = "claude",
    -- claude = {
    --   endpoint = "https://api.anthropic.com",
    --   model = "claude-3-5-sonnet-20241022",
    --   temperature = 0,
    --   max_tokens = 4096,
    -- },
  },
  config = function()
    require("avante").setup({})
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("avante-tweaks", { clear = true }),
      pattern = { "AvanteInput", "AvanteSelectedFiles", "Avante" },
      callback = function()
        vim.opt_local.laststatus = 0
        vim.cmd([[ echom 'lmao' ]])
      end,
    })
  end,
}
