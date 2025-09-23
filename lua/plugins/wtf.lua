return {
  "piersolenski/wtf.nvim",
  dependencies = {
    { "MunifTanjim/nui.nvim", version = false },
  },
  opts = {
    provider = "anthropic",
    providers = {
      anthropic = {
        model_id = "claude-4-sonnet-20250514",
      },
    },
  },
}
