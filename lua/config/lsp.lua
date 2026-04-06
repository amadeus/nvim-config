-- Diagnostics config
vim.lsp._nvim_config_state = vim.lsp._nvim_config_state or {
  diagnostic_state = {},
}

local lsp_config_state = vim.lsp._nvim_config_state

if not lsp_config_state.original_start then
  lsp_config_state.original_start = vim.lsp.start

  vim.lsp.start = function(config, opts)
    opts = opts or {}
    local bufnr = vim._resolve_bufnr(opts.bufnr)
    if vim.api.nvim_buf_is_valid(bufnr) and vim.startswith(vim.api.nvim_buf_get_name(bufnr), "fugitive://") then
      return
    end

    return lsp_config_state.original_start(config, opts)
  end
end

local function pad_hover_preview(bufnr, winid, opts)
  if not (bufnr and winid) then
    return
  end

  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winid) then
    return
  end

  if not opts._update_win and vim.b[bufnr].hover_padding_applied then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local padded_lines = vim.tbl_map(function(line)
    return " " .. line .. " "
  end, lines)
  local was_modifiable = vim.bo[bufnr].modifiable

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, padded_lines)
  vim.bo[bufnr].modifiable = was_modifiable
  vim.b[bufnr].hover_padding_applied = true

  pcall(vim.api.nvim_win_set_width, winid, vim.api.nvim_win_get_width(winid) + 2)
end

if not lsp_config_state.original_open_floating_preview then
  lsp_config_state.original_open_floating_preview = vim.lsp.util.open_floating_preview

  vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
    local bufnr, winid = lsp_config_state.original_open_floating_preview(contents, syntax, opts)

    opts = opts or {}
    if opts.focus_id == "textDocument/hover" then
      pad_hover_preview(bufnr, winid, opts)
    end

    return bufnr, winid
  end
end

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
    -- this seems to have no effect...
    border = "rounded",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "●",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
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

vim.keymap.set("n", "<A-j>", function()
  vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<A-k>", function()
  vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "Go to previous diagnostic" })

-- LSP keymaps
vim.keymap.set("n", "gaa", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "gad", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostic details" })
-- vim.keymap.set("n", "grr", vim.lsp.buf.rename, { desc = "Rename symbol" })
-- vim.keymap.set("n", "gca", vim.lsp.buf.code_action, { desc = "Code action" })
-- vim.keymap.set("n", "gce", function()
--   vim.lsp.buf.format({ async = true, name = "eslint" })
-- end, { desc = "Fix with ESLint" })

-- Mapping to toggle diagnostics on and off
vim.keymap.set("n", "<leader>dz", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if lsp_config_state.diagnostic_state[bufnr] == false then
    vim.diagnostic.enable(true, { bufnr = bufnr })
    lsp_config_state.diagnostic_state[bufnr] = true
    vim.notify("Diagnostics enabled for current buffer")
  else
    vim.diagnostic.enable(false, { bufnr = bufnr })
    lsp_config_state.diagnostic_state[bufnr] = false
    vim.notify("Diagnostics disabled for current buffer")
  end
end, { desc = "Toggle diagnostics for current buffer" })

local function get_and_report_active_clients()
  local clients_list = vim.lsp.get_clients()
  local unique_client_names = {}
  if #clients_list == 0 then
    vim.notify("No LSP clients are currently connected.", vim.log.levels.INFO)
    return nil, unique_client_names
  end

  local client_names_set = {}
  for _, client in ipairs(clients_list) do
    client_names_set[client.name] = true
  end

  for name, _ in pairs(client_names_set) do
    table.insert(unique_client_names, name)
  end

  return clients_list, unique_client_names
end

vim.api.nvim_create_user_command("LspRestartAll", function()
  local clients_list, unique_client_names = get_and_report_active_clients()
  if not clients_list then
    return
  end

  vim.notify(
    "Stopping " .. #clients_list .. " LSP client instance(s): " .. table.concat(unique_client_names, ", "),
    vim.log.levels.INFO
  )
  for _, name in ipairs(unique_client_names) do
    vim.lsp.enable(name, false)
  end

  vim.defer_fn(function()
    vim.notify("Restarting LSP clients: " .. table.concat(unique_client_names, ", "), vim.log.levels.INFO)
    for _, name in ipairs(unique_client_names) do
      vim.lsp.enable(name, true)
    end
    vim.notify("LSP clients restarted: " .. table.concat(unique_client_names, ", "), vim.log.levels.INFO)
  end, 1000)
end, {
  desc = "Restart all running LSP clients",
  force = true,
})

vim.api.nvim_create_user_command("LspKill", function()
  local clients_list, unique_client_names = get_and_report_active_clients()
  if not clients_list then
    return
  end

  vim.notify(
    "Hard stopping " .. #clients_list .. " LSP client instance(s): " .. table.concat(unique_client_names, ", "),
    vim.log.levels.INFO
  )
  for _, name in ipairs(unique_client_names) do
    vim.lsp.enable(name, false)
  end
  vim.notify("All LSP clients stopped.", vim.log.levels.INFO)
end, {
  desc = "Hard stop all running LSP clients",
  force = true,
})

return {}
