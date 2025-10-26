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
    -- this seems to have no effect...
    border = "rounded",
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

-- Detach LSP from non-file buffers (fugitive, diff buffers, etc.)
-- This does not work right now, i may need to revisit another time
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("LspDetachNonFiles", { clear = true }),
--   callback = function(args)
--     local bufnr = args.buf
--     local uri = vim.uri_from_bufnr(bufnr)
--     local filetype = vim.bo[bufnr].filetype
--     local bufname = vim.api.nvim_buf_get_name(bufnr)
--
--     if
--       (uri and not uri:match("^file://"))
--       or filetype == "diff"
--       or bufname:match("^fugitive://")
--       or bufname:match("%.git/")
--     then
--       vim.lsp.buf_detach(bufnr)
--     end
--   end,
-- })

vim.keymap.set("n", "<A-j>", function()
  vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<A-k>", function()
  vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "Go to previous diagnostic" })

-- LSP keymaps
vim.keymap.set("n", "gaa", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "gad", vim.diagnostic.open_float, { desc = "Show diagnostic details" })
vim.keymap.set("n", "gfe", function()
  vim.lsp.buf.format({ async = true, name = "eslint" })
end, { desc = "Fix with ESLint" })

vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "gca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Mapping to toggle diagnostics on and off
local diagnostic_state = {}
vim.keymap.set("n", "<leader>dz", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if diagnostic_state[bufnr] == false then
    vim.diagnostic.enable(true, { bufnr = bufnr })
    diagnostic_state[bufnr] = true
    vim.notify("Diagnostics enabled for current buffer")
  else
    vim.diagnostic.enable(false, { bufnr = bufnr })
    diagnostic_state[bufnr] = false
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
})

return {}
