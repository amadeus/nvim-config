return {
  "github/copilot.vim",
  version = false,
  init = function()
    vim.g.copilot_filetypes = { ["*"] = false }
  end,
}
