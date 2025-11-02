return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  opts = {
    preset = "powerline",
    options = {
      show_source = {
        enabled = true,
        if_many = true,
      },
      multilines = {
        enabled = false,
        always_show = false,
        tabstop = 2,
      },
      set_arrow_to_diag_color = true,
      show_all_diags_on_cursorline = false,
      override_open_float = true,
    },
  },
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
    vim.diagnostic.config({ virtual_text = false })
    vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float
  end,
}
