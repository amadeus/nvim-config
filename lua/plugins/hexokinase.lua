return {
  "RRethy/vim-hexokinase",
  enabled = false,
  version = false,
  build = "make hexokinase",
  init = function()
    vim.g.Hexokinase_highlighters = { "virtual" }
    vim.g.Hexokinase_ftEnabled = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "lua",
    }
  end,
}
