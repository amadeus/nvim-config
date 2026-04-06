local cursorline_group = vim.api.nvim_create_augroup("cursorline_number_focus", { clear = true })

local function is_floating_window(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end

  return vim.api.nvim_win_get_config(win).relative ~= ""
end

local function set_winhighlight(win, source, target)
  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  local entries = {}
  local current = vim.wo[win].winhighlight

  for _, entry in ipairs(vim.split(current, ",", { trimempty = true })) do
    local from, to = entry:match("^([^:]+):(.+)$")
    if from and from ~= source then
      table.insert(entries, from .. ":" .. to)
    end
  end

  if target then
    table.insert(entries, source .. ":" .. target)
  end

  vim.wo[win].winhighlight = table.concat(entries, ",")
end

local function refresh_cursorline_number_focus()
  local current_win = vim.api.nvim_get_current_win()

  -- Completion and other transient floating windows should not
  -- change which editing window looks focused.
  if is_floating_window(current_win) then
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not is_floating_window(win) then
      if win == current_win then
        set_winhighlight(win, "CursorLineNr", nil)
      else
        set_winhighlight(win, "CursorLineNr", "CursorLineNrInactive")
      end
    end
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "ColorScheme", "TabEnter", "WinClosed", "WinEnter", "WinNew" }, {
  group = cursorline_group,
  desc = "Dim CursorLineNr in inactive windows",
  callback = refresh_cursorline_number_focus,
})

refresh_cursorline_number_focus()

return {}
