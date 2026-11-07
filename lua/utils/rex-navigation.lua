local directions = { h = "left", j = "down", k = "up", l = "right" }

local M = {}

local function rex_executable()
  local bin_dir = vim.env.REX_BIN_DIR
  if not bin_dir or bin_dir == "" then
    return nil
  end

  local rex = vim.fs.joinpath(bin_dir, "rex")
  if vim.fn.executable(rex) ~= 1 then
    return nil
  end

  return rex
end

local function notify_failure(result, message)
  if result.code ~= 0 then
    vim.schedule(function()
      local detail = vim.trim(result.stderr or "")
      vim.notify(detail ~= "" and detail or message, vim.log.levels.WARN)
    end)
  end
end

function M.navigate_window(key, terminal)
  local fallback = (terminal and "<C-\\><C-n>" or "") .. "<C-w>" .. key
  local session = vim.env.REX_SESSION
  local block = vim.env.REX_BLOCK
  if not session or session == "" or not block or block == "" or vim.fn.winnr(key) ~= vim.fn.winnr() then
    return fallback
  end

  local rex = rex_executable()
  if not rex then
    return fallback
  end

  -- Preserve terminal input mode when handing focus to the outer pane.
  -- Background pane creation can leave Rex's server focused on another tab.
  vim.system({ rex, "--autostart=false", "focus", "-s", session, block }, { text = true }, function(result)
    if result.code ~= 0 then
      notify_failure(result, "Rex pane focus failed")
      return
    end

    vim.system(
      { rex, "--autostart=false", "focus", "-s", session, directions[key] },
      { text = true },
      function(nav_result)
        notify_failure(nav_result, "Rex pane navigation failed")
      end
    )
  end)
  return "<Ignore>"
end

function M.toggle_zoom()
  local fallback = "<C-w>O"
  local session = vim.env.REX_SESSION
  local block = vim.env.REX_BLOCK
  if not session or session == "" or not block or block == "" then
    return fallback
  end

  local rex = rex_executable()
  if not rex then
    return fallback
  end

  vim.system({ rex, "--autostart=false", "zoom", "-s", session, block }, { text = true }, function(result)
    notify_failure(result, "Rex pane zoom failed")
  end)
  return "<Ignore>"
end

function M.equalize_splits(terminal)
  local fallback = terminal and "<Cmd>wincmd =<CR>" or "<C-w>="
  local session = vim.env.REX_SESSION
  local block = vim.env.REX_BLOCK
  if not session or session == "" or not block or block == "" then
    return fallback
  end

  local rex = rex_executable()
  if not rex then
    return fallback
  end

  vim.system(
    { rex, "--autostart=false", "block", "call", "-s", session, "-b", block, "size" },
    { text = true },
    function(result)
      if result.code ~= 0 then
        notify_failure(result, "Rex pane owner lookup failed")
        return
      end

      local ok, size = pcall(vim.json.decode, result.stdout or "")
      local client = ok and type(size) == "table" and size.owner or nil
      if type(client) ~= "string" or client == "" then
        notify_failure({ code = 1 }, "Rex pane owner lookup failed")
        return
      end

      vim.system({
        rex,
        "--autostart=false",
        "-C",
        client,
        "do",
        "pane.balance",
        "-s",
        session,
        "-b",
        block,
      }, { text = true }, function(balance_result)
        notify_failure(balance_result, "Rex pane balancing failed")
      end)
    end
  )

  return fallback
end

return M
