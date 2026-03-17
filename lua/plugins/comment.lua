return {
  "numToStr/Comment.nvim",
  dependencies = {
    { "amadeus/nvim-ts-context-commentstring", branch = "neovim-nightly-fix" },
  },
  opts = {
    padding = true,
    sticky = true,
    toggler = {
      line = "gcc",
      block = "gcb",
    },
  },
  config = function(_, opts)
    opts.pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    require("Comment").setup(opts)
  end,
}
