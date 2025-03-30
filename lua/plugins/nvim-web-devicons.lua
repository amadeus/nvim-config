return {
  "nvim-tree/nvim-web-devicons",
  enabled = false,
  config = function()
    require("nvim-web-devicons").setup({
      color_icons = true,
      -- globally enable default icons (default to false)
      -- will get overriden by `get_icons` option
      default = true,
    })
  end,
}
