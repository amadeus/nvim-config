return {
  "dlants/magenta.nvim",
  -- Definitely a potentially neat plugin, but also it's split control is
  -- really fucking annoying...
  enabled = false,
  version = false,
  build = "npm install --frozen-lockfile",
  opts = {
    sidebarPosition = "right",
    picker = "telescope",
    defaultKeymaps = false,
    sidebarKeymaps = {
      normal = {
        ["<c-cr>"] = ":Magenta send<CR>",
      },
      insert = {
        ["<c-cr>"] = ":Magenta send<CR>",
      },
    },
  },
  config = function(_, opts)
    require("magenta").setup(opts)
  end,
}
