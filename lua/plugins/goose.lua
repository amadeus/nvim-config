return {
  "azorng/goose.nvim",
  branch = "main",
  -- Currently not super happy with this because it appears to lack an easy way
  -- to customize the popups that it creates. Also fwiw, I am a bit scared that
  -- this agent can just go ham and do stuff you may not want it to do.  It
  -- could be powerful at some point tho...
  enabled = false,
  opts = {
    keymap = {
      global = {
        open_input = "<leader>cc",
        open_input_new_session = "<leader>cI",
        open_output = "<leader>co",
        close = "<leader>cq",
        toggle_fullscreen = "<leader>cf",
        select_session = "<leader>cs",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- {
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   opts = {
    --     anti_conceal = { enabled = false },
    --   },
    -- },
  },
}
