local function get_format_options(bufnr, ignore_disable)
  local is_disabled = not ignore_disable
    and (vim.b[bufnr].conform_disable_formatting == true or vim.g.conform_disable_formatting == true)

  if is_disabled then
    return nil
  end

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
      local config = get_format_options(vim.api.nvim_get_current_buf(), true)
      if config then
        conform.format(config)
      end
    end, { desc = "Format document" })

    -- Disable local buffer formatting on save
    vim.keymap.set("n", "<leader>ft", function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.b[bufnr].conform_disable_formatting == true then
        vim.b[bufnr].conform_disable_formatting = nil
        vim.notify("Auto formatting on save enabled for this buffer")
      else
        vim.b[bufnr].conform_disable_formatting = true
        vim.notify("Auto formatting on save disabled for this buffer")
      end
    end, { desc = "Toggle format on save for current buffer" })

    -- Disable buffer format on save globally
    vim.keymap.set("n", "<leader>fT", function()
      if vim.g.conform_disable_formatting == true then
        vim.g.conform_disable_formatting = nil
        vim.notify("Auto formatting on save enabled globally")
      else
        vim.g.conform_disable_formatting = true
        vim.notify("Auto formatting on save disabled globally")
      end
    end, { desc = "Toggle format on save globally" })
  end,
}
