-- Diagnostics config
local lsp_group = vim.api.nvim_create_augroup("nvim_config_lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  desc = "Detach LSP clients from Fugitive buffers",
  callback = function(args)
    if not vim.startswith(vim.api.nvim_buf_get_name(args.buf), "fugitive://") then
      return
    end

    local client_id = args.data and args.data.client_id
    if not client_id then
      return
    end

    -- Wait until Neovim finishes its scheduled attachment setup before
    -- detaching so no capabilities are re-enabled afterward.
    vim.schedule(function()
      vim.schedule(function()
        local client = vim.lsp.get_client_by_id(client_id)
        if
          not client
          or not vim.api.nvim_buf_is_valid(args.buf)
          or not vim.lsp.buf_is_attached(args.buf, client_id)
        then
          return
        end

        vim.lsp.buf_detach_client(args.buf, client_id)
        if vim.tbl_isempty(client.attached_buffers) then
          client:stop()
        end
      end)
    end)
  end,
})

local function pad_hover_preview(bufnr, winid)
  if not (bufnr and winid) then
    return
  end

  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winid) then
    return
  end

  if vim.b[bufnr].hover_padding_applied then
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

  local width = vim.api.nvim_win_get_width(winid) + 2
  if vim.api.nvim_win_resize then
    local config = vim.api.nvim_win_get_config(winid)
    local anchor = vim.endswith(config.anchor or "", "E") and "right" or "left"
    pcall(vim.api.nvim_win_resize, winid, width, -1, { anchor = anchor })
  else
    ---@diagnostic disable-next-line: deprecated
    pcall(vim.api.nvim_win_set_width, winid, width)
  end
end

vim.api.nvim_create_autocmd("WinNew", {
  group = lsp_group,
  desc = "Add horizontal padding to LSP hover windows",
  callback = function()
    vim.schedule(function()
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local is_hover = pcall(vim.api.nvim_win_get_var, winid, "textDocument/hover")
        if is_hover then
          pad_hover_preview(vim.api.nvim_win_get_buf(winid), winid)
        end
      end
    end)
  end,
})

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
  local enabled = not vim.diagnostic.is_enabled({ bufnr = bufnr })
  vim.diagnostic.enable(enabled, { bufnr = bufnr })
  vim.notify("Diagnostics " .. (enabled and "enabled" or "disabled") .. " for current buffer")
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
