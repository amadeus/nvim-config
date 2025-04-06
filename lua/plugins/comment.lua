return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
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
