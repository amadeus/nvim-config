return {
  "RRethy/vim-hexokinase",
  build = "make hexokinase",
  config = function()
    vim.g.Hexokinase_highlighters = { "virtual" }
    vim.g.Hexokinase_ftEnabled = {
      "css", "html", "javascript", "typescript", "typescriptreact", "typescript.tsx", "javascript.jsx"
    }
  end
}
