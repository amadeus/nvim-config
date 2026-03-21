return {
  "piersolenski/wtf.nvim",
  cmd = {
    "Wtf",
    "WtfFix",
    "WtfGrepHistory",
    "WtfHistory",
    "WtfPickProvider",
    "WtfSearch",
  },
  dependencies = {
    { "MunifTanjim/nui.nvim", version = false },
    { "nvim-lua/plenary.nvim", version = false },
  },
  opts = {
    provider = "anthropic",
  },
}
