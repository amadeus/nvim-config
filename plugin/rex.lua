local directions = { h = "left", j = "down", k = "up", l = "right" }

local function rex_context()
  local session = vim.env.REX_SESSION
  local block = vim.env.REX_BLOCK
  if not session or session == "" or not block or block == "" then
    return nil, "Title requires a Rex pane"
  end

  local bin_dir = vim.env.REX_BIN_DIR
  if bin_dir and bin_dir ~= "" then
    local executable = vim.fs.joinpath(bin_dir, "rex")
    if vim.fn.executable(executable) == 1 then
      return { executable = executable, session = session, block = block }
    end
  end
  return nil, "Rex executable unavailable"
end

local function notify_failure(result, message)
  if result.code ~= 0 then
    vim.schedule(function()
      local detail = vim.trim(result.stderr or "")
      vim.notify(detail ~= "" and detail or message, vim.log.levels.WARN)
    end)
  end
end

local original_titles = {}
local title_queue = {}

-- Finish each inspect/rename before the next :Title can read or restore its label.
local function run_title_command()
  local request = title_queue[1]
  local rex = request.rex
  local original = original_titles[rex.block]

  local function finish()
    table.remove(title_queue, 1)
    if title_queue[1] then
      run_title_command()
    end
  end

  local function run(args, on_success, failure_message, on_failure)
    on_failure = on_failure or finish
    local cmd = { rex.executable, "--autostart=false", "block" }
    vim.list_extend(cmd, args)
    local ok, err = pcall(
      vim.system,
      cmd,
      { text = true },
      vim.schedule_wrap(function(result)
        if result.code == 0 and result.signal == 0 then
          on_success(result)
        else
          local detail = vim.trim(result.stderr or "")
          vim.notify(detail ~= "" and detail or failure_message, vim.log.levels.WARN)
          on_failure()
        end
      end)
    )
    if not ok then
      vim.notify(tostring(err), vim.log.levels.WARN)
      finish()
    end
  end

  local function inspect_label(on_success)
    run({ "inspect", "-s", rex.session, "--json", "--", rex.block }, function(result)
      local ok, data = pcall(vim.json.decode, result.stdout or "")
      local label = ok and type(data) == "table" and type(data.block) == "table" and data.block.label
      if type(label) ~= "string" then
        vim.notify("Could not read the original Rex pane title", vim.log.levels.WARN)
        finish()
        return
      end
      on_success(label)
    end, "Rex pane inspection failed")
  end

  local function rename(on_failure)
    local reset = request.title == ""
    local label = reset and original or request.title
    run({ "rename", "-s", rex.session, "--", rex.block, label }, function()
      if reset then
        original_titles[rex.block] = nil
      else
        original_titles[rex.block] = original
      end
      finish()
    end, "Rex pane rename failed", on_failure)
  end

  if original ~= nil then
    rename()
  elseif request.title == "" then
    finish()
  else
    inspect_label(function(label)
      original = label
      rename(function()
        -- Rex may have applied the rename before the CLI lost its reply.
        original_titles[rex.block] = original
        inspect_label(function(current)
          if current == original then
            original_titles[rex.block] = nil
          end
          finish()
        end)
      end)
    end)
  end
end

vim.api.nvim_create_user_command("Title", function(opts)
  local rex, err = rex_context()
  if err then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  table.insert(title_queue, { rex = rex, title = opts.args })
  if #title_queue == 1 then
    run_title_command()
  end
end, { nargs = "?", desc = "Set or restore the current Rex pane title" })

local function navigate_window(key, terminal)
  local fallback = (terminal and "<C-\\><C-n>" or "") .. "<C-w>" .. key
  if vim.fn.winnr(key) ~= vim.fn.winnr() then
    return fallback
  end

  local rex = rex_context()
  if not rex then
    return fallback
  end

  -- Preserve terminal input mode when handing focus to the outer pane.
  -- Background pane creation can leave Rex's server focused on another tab.
  vim.system(
    { rex.executable, "--autostart=false", "focus", "-s", rex.session, rex.block },
    { text = true },
    function(result)
      if result.code ~= 0 then
        notify_failure(result, "Rex pane focus failed")
        return
      end

      vim.system(
        { rex.executable, "--autostart=false", "focus", "-s", rex.session, directions[key] },
        { text = true },
        function(nav_result)
          notify_failure(nav_result, "Rex pane navigation failed")
        end
      )
    end
  )
  return "<Ignore>"
end

local function toggle_zoom()
  local fallback = "<C-w>O"
  local rex = rex_context()
  if not rex then
    return fallback
  end

  vim.system(
    { rex.executable, "--autostart=false", "zoom", "-s", rex.session, rex.block },
    { text = true },
    function(result)
      notify_failure(result, "Rex pane zoom failed")
    end
  )
  return "<Ignore>"
end

local function equalize_splits(terminal)
  local fallback = terminal and "<Cmd>wincmd =<CR>" or "<C-w>="
  local rex = rex_context()
  if not rex then
    return fallback
  end

  vim.system(
    { rex.executable, "--autostart=false", "block", "call", "-s", rex.session, "-b", rex.block, "size" },
    { text = true },
    function(result)
      if result.code ~= 0 then
        return
      end

      local ok, size = pcall(vim.json.decode, result.stdout or "")
      local client = ok and type(size) == "table" and size.owner or nil
      if type(client) ~= "string" or client == "" then
        return
      end

      vim.system({
        rex.executable,
        "--autostart=false",
        "-C",
        client,
        "do",
        "pane.balance",
        "-s",
        rex.session,
        "-b",
        rex.block,
      }, { text = true })
    end
  )

  return fallback
end

local function map_window_keys(modes, terminal)
  for key in pairs(directions) do
    for _, suffix in ipairs({ key, "<C-" .. key .. ">" }) do
      vim.keymap.set(modes, "<C-w>" .. suffix, function()
        return navigate_window(key, terminal)
      end, { expr = true, desc = "Navigate Neovim or Rex panes" })
    end
  end

  vim.keymap.set(modes, "<C-w>=", function()
    return equalize_splits(terminal)
  end, { expr = true, desc = "Equalize Neovim and Rex panes" })
end

map_window_keys({ "n", "x" }, false)
map_window_keys("t", true)
vim.keymap.set({ "n", "x", "t" }, "<C-w>O", toggle_zoom, { expr = true, desc = "Toggle Rex pane zoom" })
