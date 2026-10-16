local directions = { h = "left", j = "down", k = "up", l = "right" }

return function(key, terminal)
  local fallback = (terminal and "<C-\\><C-n>" or "") .. "<C-w>" .. key
  local session = vim.env.REX_SESSION
  if not session or session == "" or vim.fn.winnr(key) ~= vim.fn.winnr() then
    return fallback
  end

  local rex = vim.fn.exepath("rex")
  if rex == "" then
    rex = "/Applications/Rex.app/Contents/Helpers/Rex Server.app/Contents/MacOS/rex"
  end
  if vim.fn.executable(rex) ~= 1 then
    return fallback
  end

  -- Preserve terminal input mode when handing focus to the outer pane.
  vim.system({ rex, "--autostart=false", "focus", "-s", session, directions[key] }, { text = true }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify(vim.trim(result.stderr or "Rex pane navigation failed"), vim.log.levels.WARN)
      end)
    end
  end)
  return ""
end
