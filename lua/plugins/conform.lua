return {
  "stevearc/conform.nvim",
  version = "*",
  config = function()
    require("conform").setup({
      -- Define formatters by filetype
      formatters_by_ft = {
        javascript = { "prettier", "biome" },
        typescript = { "prettier", "biome" },
        javascriptreact = { "prettier", "biome" },
        typescriptreact = { "prettier", "biome" },
        json = { "prettier", "biome" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      -- Format on save
      -- format_on_save = {
      --   lsp_fallback = true,
      --   timeout_ms = 500,
      -- },
    })

    -- Formatting (equivalent to ALEFix)
    vim.keymap.set("n", "<leader>ff", function()
      require("conform").format({
        lsp_fallback = true,
        timeout_ms = 2000,
      })
    end, { desc = "Format document" })

    -- .lvimrc snippet to fix on save
    -- if has('nvim')
    -- lua <<EOF
    -- require("conform").setup({
    --   format_on_save = {
    --     lsp_fallback = true,
    --     timeout_ms = 2000,
    --   },
    -- })
    -- EOF
    -- endif
  end,
}
