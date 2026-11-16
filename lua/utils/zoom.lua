-- Zoom the current window into its own tab, leaving the original layout
-- untouched. Toggling from anywhere in the zoom tab closes it and returns to
-- the window that was zoomed. The zoom state lives on the zoom tab itself, so
-- it is cleared whenever that tab goes away.
local M = {}

local function refresh_tabline()
  if package.loaded.lualine then
    require("lualine").refresh({ place = { "tabline" } })
  end
end

local function is_floating(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

local function unzoom(zoom)
  local zoom_tab = vim.api.nvim_get_current_tabpage()

  -- Without the original tab there is nothing to return to, so the zoom tab
  -- just becomes a normal tab.
  if not vim.api.nvim_tabpage_is_valid(zoom.tab) then
    vim.t.zoom = nil
    refresh_tabline()
    return
  end

  vim.api.nvim_set_current_tabpage(zoom.tab)
  if vim.api.nvim_win_is_valid(zoom.win) and vim.api.nvim_win_get_tabpage(zoom.win) == zoom.tab then
    vim.api.nvim_set_current_win(zoom.win)
  end
  vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(zoom_tab))
end

function M.toggle()
  local zoom = vim.t.zoom
  if zoom then
    unzoom(zoom)
    return
  end

  local win = vim.api.nvim_get_current_win()
  if is_floating(win) then
    return
  end

  local tab = vim.api.nvim_get_current_tabpage()
  local windows = vim.tbl_filter(function(w)
    return not is_floating(w)
  end, vim.api.nvim_tabpage_list_wins(tab))
  if #windows < 2 then
    return
  end

  vim.cmd("tab split")
  vim.t.zoom = { tab = tab, win = win }
  refresh_tabline()
end

return M
