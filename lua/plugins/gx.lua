return {
  "chrishrb/gx.nvim",
  version = false,
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  submodules = false,
  init = function()
    -- disable netrw gx
    vim.g.netrw_nogx = 1
  end,
  opts = {
    handlers = {
      plugin = true,
      github = true,
      brewfile = true,
      package_json = true,
      search = false,
    },
  },
  config = function(_, opts)
    require("gx").setup(opts)
  end,
}
