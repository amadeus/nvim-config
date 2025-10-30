return {
  "piersolenski/wtf.nvim",
  dependencies = {
    { "MunifTanjim/nui.nvim", version = false },
  },
  opts = {
    provider = "anthropic",
    providers = {
      anthropic = {
        model_id = "claude-sonnet-4-5-20250929",
      },
    },
  },
}
