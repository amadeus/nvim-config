return {
  "github/copilot.vim",
  version = false,
  enabled = false,
  init = function()
    vim.g.copilot_filetypes = { ["*"] = false }
  end,
}
