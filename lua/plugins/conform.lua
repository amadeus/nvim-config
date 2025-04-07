local function get_format_options(bufnr)
  bufnr = bufnr or 0
  local default_config = vim.g.project_format_options or nil

  if not vim.g.project_formatters then
    return default_config
  end

  local formatters = vim.g.project_formatters[vim.bo[bufnr].filetype]
  if formatters then
    -- Lets create a new config that's a merge of default_config with a
    -- formatters field
    local config = vim.tbl_extend(
      "force",
      {},
      default_config or { lsp_fallback = false, timeout_ms = 1000 },
      { formatters = formatters }
    )
    return config
  end

  return default_config
end

return {
  "stevearc/conform.nvim",
  version = "*",
  config = function()
    local conform = require("conform")

    conform.setup({
      format_on_save = get_format_options,
    })

    -- Formatting (equivalent to ALEFix)
    vim.keymap.set("n", "<leader>ff", function()
      local config = get_format_options(vim.api.nvim_get_current_buf())
      if config then
        conform.format(config)
      end
    end, { desc = "Format document" })
  end,
}
