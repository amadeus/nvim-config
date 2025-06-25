return {
  "azorng/goose.nvim",
  version = false,
  -- Currently not super happy with this because it appears to lack an easy way
  -- to customize the popups that it creates. Also fwiw, I am a bit scared that
  -- this agent can just go ham and do stuff you may not want it to do.  It
  -- could be powerful at some point tho...
  -- Played with it again -- still has issues
  --  * UI sucks -- why can't it be a split? Why is word wrap off by default?
  --  * Why can't it access files I specify? It claims they are blank...
  --  (perhaps a goose misconfiguration)
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
      window = {
        submit = "<c-cr>",
      },
    },
  },
  dependencies = {
    -- {
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   opts = {
    --     anti_conceal = { enabled = false },
    --   },
    -- },
  },
}
