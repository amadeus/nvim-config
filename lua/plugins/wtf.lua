return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    provider = "gemini",
    providers = {
      gemini = {
        model_id = "gemini-2.5-flash",
      },
    },
  },
}
