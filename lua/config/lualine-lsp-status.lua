-- AI Slop Ahead... not sure if this is the best way to do this, but here we
-- are
local LspStatus = require("lualine.component"):extend()

local lsp_progress = {
  initialized = false,
  work_by_client_id = {},
}

lsp_progress.setup = function()
  if lsp_progress.initialized then
    return
  end

  vim.api.nvim_create_autocmd("LspProgress", {
    desc = "Track LSP progress for minimal status display",
    group = vim.api.nvim_create_augroup("lualine_minimal_lsp_progress", { clear = true }),
    callback = function(event)
      local kind = event.data.params.value.kind
      local client_id = event.data.client_id

      local work = lsp_progress.work_by_client_id[client_id] or 0
      local work_change = kind == "begin" and 1 or (kind == "end" and -1 or 0)

      lsp_progress.work_by_client_id[client_id] = math.max(work + work_change, 0)

      if (work == 0 and work_change > 0) or (work == 1 and work_change < 0) then
        require("lualine").refresh()
      end
    end,
  })

  lsp_progress.initialized = true
end

local default_options = {
  spinner_symbols = { "𜶫", "𜷚", "𜷣", "𜷥", "𜷤", "𜷠", "𜷊", "𜵰" },
  done_symbol = "✓",
  spinner_interval = 80,
}

function LspStatus:init(options)
  LspStatus.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
  lsp_progress.setup()
end

function LspStatus:update_status()
  local get_lsp_clients = vim.lsp.get_clients
  local clients = get_lsp_clients({ bufnr = vim.api.nvim_get_current_buf() })
  if #clients == 0 then
    return ""
  end

  local any_busy = false
  for _, client in ipairs(clients) do
    local work = lsp_progress.work_by_client_id[client.id] or 0
    if work > 0 then
      any_busy = true
      break
    end
  end

  if any_busy then
    local hrtime = (vim.uv or vim.loop).hrtime
    local spinner_idx = math.floor(hrtime() / (1e6 * self.options.spinner_interval)) % #self.options.spinner_symbols + 1
    return "💡 " .. self.options.spinner_symbols[spinner_idx]
  else
    return self.options.done_symbol
  end
end

return LspStatus
