-- Diagnostics config
vim.diagnostic.config({
  virtual_text = {
    prefix = "",
    suffix = "",
    spacing = 0,
    source = false,
    current_line = true,
    virt_text_pos = "eol",
    hl_mode = "replace",
    severity = {
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.INFO,
      vim.diagnostic.severity.HINT,
    },
  },
  float = {
    border = "solid",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "e",
      [vim.diagnostic.severity.WARN] = "w",
      [vim.diagnostic.severity.INFO] = "i",
      [vim.diagnostic.severity.HINT] = "h",
    },
  },
  underline = {
    severity = {
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.ERROR,
    },
  },
  update_in_insert = false,
  severity_sort = true,
})

-- Configure diagnostic navigation keymaps
if vim.g.neovide then
  vim.keymap.set("n", "∆", function()
    vim.diagnostic.jump({ count = 1, float = false })
  end, { desc = "Go to next diagnostic" })
  vim.keymap.set("n", "˚", function()
    vim.diagnostic.jump({ count = -1, float = false })
  end, { desc = "Go to previous diagnostic" })
else
  vim.keymap.set("n", "<A-j>", function()
    vim.diagnostic.jump({ count = 1, float = false })
  end, { desc = "Go to next diagnostic" })
  vim.keymap.set("n", "<A-k>", function()
    vim.diagnostic.jump({ count = -1, float = false })
  end, { desc = "Go to previous diagnostic" })
end

-- LSP keymaps
vim.keymap.set("n", "<leader>aa", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "<leader>ad", vim.diagnostic.open_float, { desc = "Show diagnostic details" })
vim.keymap.set("n", "<leader>fe", function()
  vim.lsp.buf.format({ async = true, name = "eslint" })
end, { desc = "Fix with ESLint" })

vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

return {}

