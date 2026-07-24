local sidekick_gutter_options = { "number", "relativenumber", "signcolumn", "statuscolumn" }
local sidekick_normal_window_options = {
  number = true,
  relativenumber = false,
  signcolumn = "yes",
  statuscolumn = [[%{%v:lua.utils.fold.statuscolumn()%}]],
}

local function sidekick_win_get_var(win, name)
  local ok, value = pcall(vim.api.nvim_win_get_var, win, name)
  if ok then
    return value
  end
end

local function sidekick_win_del_var(win, name)
  pcall(vim.api.nvim_win_del_var, win, name)
end

local function sidekick_win_set_option(win, option, value)
  pcall(function()
    vim.wo[win][option] = value
  end)
end

local function sidekick_is_buffer(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  return vim.bo[buf].filetype == "sidekick_terminal" or vim.b[buf].sidekick_cli ~= nil
end

local function sidekick_restore_gutter_options(win)
  for _, option in ipairs(sidekick_gutter_options) do
    sidekick_win_set_option(win, option, sidekick_normal_window_options[option])
  end
end

local function sidekick_detach_terminal_window(session_id, win)
  local Terminal = package.loaded["sidekick.cli.terminal"]
  if not Terminal or not Terminal.terminals then
    return
  end

  local terminal = Terminal.terminals[session_id]
  if terminal and terminal.win == win then
    terminal.win = nil
  end
end

local function sidekick_cleanup_stale_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end

  local session_id = sidekick_win_get_var(win, "sidekick_session_id")
  local cli = sidekick_win_get_var(win, "sidekick_cli")
  if not session_id and not cli then
    return
  end

  if sidekick_is_buffer(vim.api.nvim_win_get_buf(win)) then
    return
  end

  sidekick_restore_gutter_options(win)
  sidekick_win_del_var(win, "sidekick_cli")
  sidekick_win_del_var(win, "sidekick_session_id")

  if session_id then
    sidekick_detach_terminal_window(session_id, win)
  end
end

local function sidekick_cleanup_stale_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    sidekick_cleanup_stale_window(win)
  end
end

local function sidekick_setup_stale_window_cleanup()
  local group = vim.api.nvim_create_augroup("sidekick_stale_window_cleanup", { clear = true })
  local scheduled = false

  local function schedule_cleanup()
    if scheduled then
      return
    end

    scheduled = true
    vim.schedule(function()
      scheduled = false
      sidekick_cleanup_stale_windows()
    end)
  end

  vim.api.nvim_create_autocmd(
    { "VimEnter", "BufEnter", "BufWinEnter", "BufFilePost", "BufReadPost", "WinEnter", "TermClose", "TermLeave" },
    {
      group = group,
      callback = schedule_cleanup,
    }
  )
end

local sidekick_notification_events = {
  permission = {
    level = vim.log.levels.WARN,
    message = "Permission required",
  },
  waiting = {
    level = vim.log.levels.INFO,
    message = "Waiting for input",
  },
}

local sidekick_tool_titles = {
  claude = "Claude",
  codex = "Codex",
  opencode = "OpenCode",
}

local function sidekick_tool_name(tool)
  if type(tool) == "table" then
    tool = tool.name
  end

  if type(tool) == "string" and tool ~= "" then
    return tool
  end
end

local function sidekick_tool_visible(tool)
  local name = sidekick_tool_name(tool)
  if not name then
    return false
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if sidekick_is_buffer(buf) and sidekick_tool_name(sidekick_win_get_var(win, "sidekick_cli")) == name then
      return true
    end
  end

  return false
end

local function sidekick_tool_title(tool)
  tool = sidekick_tool_name(tool)
  if not tool then
    return "Sidekick"
  end

  return sidekick_tool_titles[tool] or tool:gsub("^%l", string.upper)
end

local function sidekick_notify(tool, message, level)
  vim.notify(message, level or vim.log.levels.INFO, {
    title = sidekick_tool_title(tool),
  })
end

local function sidekick_setup_notifications()
  local group = vim.api.nvim_create_augroup("sidekick_notifications", { clear = true })

  vim.api.nvim_create_user_command("SidekickNotify", function(opts)
    if #opts.fargs ~= 2 then
      sidekick_notify(nil, "Usage: SidekickNotify <tool> <waiting|permission>", vim.log.levels.ERROR)
      return
    end

    local notification = sidekick_notification_events[opts.fargs[2]]
    if not notification then
      sidekick_notify(opts.fargs[1], "Unknown notification event: " .. opts.fargs[2], vim.log.levels.ERROR)
      return
    end

    if sidekick_tool_visible(opts.fargs[1]) then
      return
    end

    sidekick_notify(opts.fargs[1], notification.message, notification.level)
  end, {
    desc = "Show a Sidekick AI notification",
    nargs = "+",
  })

  vim.api.nvim_create_autocmd("TermRequest", {
    group = group,
    desc = "Forward Sidekick OSC 9 notifications to vim.notify",
    callback = function(event)
      if not sidekick_is_buffer(event.buf) then
        return
      end

      local message = event.data.sequence:match("^\27%]9;(.*)$")
      local notification = message and sidekick_notification_events[message:match("^sidekick:([%w_-]+)$")]
      local tool = vim.b[event.buf].sidekick_cli
      if notification and not sidekick_tool_visible(tool) then
        sidekick_notify(tool, notification.message, notification.level)
      end
    end,
  })
end

local function sidekick_init()
  sidekick_setup_stale_window_cleanup()
  sidekick_setup_notifications()
end

return {
  "amadeus/sidekick.nvim",
  -- "folke/sidekick.nvim",
  enabled = true,
  cmd = { "Sidekick" },
  init = sidekick_init,
  opts = {
    nes = { enabled = false },
    cli = {
      tools = {
        claude = {
          cmd = { "claude", "--settings", vim.fn.expand("~/.claude/sidekick-settings.json") },
        },
        codex = {
          cmd = { "codex", "--profile", "sidekick" },
        },
        amp = {
          cmd = { "amp" },
          format = function(text)
            local Text = require("sidekick.text")
            Text.transform(text, function(str)
              return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
            end, "SidekickLocFile")
            local ret = Text.to_string(text)
            -- transform line ranges to a format that amp understands
            ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-L(%d+):C%d+", "@%1#L%2-%3") -- @file :L5:C20-L6:C8 => @file#L5-6
            ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-C%d+", "@%1#L%2") -- @file :L5:C9-C29 => @file#L5
            ret = ret:gsub("@([^ ]+)%s*:L(%d+)%-L(%d+)", "@%1#L%2-%3") -- @file :L5-L13 => @file#L5-13
            ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+", "@%1#L%2") -- @file :L5:C9 => @file#L5
            ret = ret:gsub("@([^ ]+)%s*:L(%d+)", "@%1#L%2") -- @file :L5 => @file#L5
            return ret
          end,
        },
      },
      win = {
        config = function(terminal)
          local function terminal_buffer(buf)
            if terminal.buf and buf == terminal.buf then
              return true
            end

            local scrollback = terminal.scrollback
            return scrollback and scrollback.buf and buf == scrollback.buf
          end

          local function window_has_terminal_buffer(win)
            return win and vim.api.nvim_win_is_valid(win) and terminal_buffer(vim.api.nvim_win_get_buf(win))
          end

          local function detach_stale_window()
            if not terminal.win then
              return
            end
            if not vim.api.nvim_win_is_valid(terminal.win) then
              terminal.win = nil
              return
            end
            if window_has_terminal_buffer(terminal.win) then
              return
            end

            sidekick_cleanup_stale_window(terminal.win)
            terminal.win = nil
          end

          local original_win_valid = terminal.win_valid
          terminal.win_valid = function(self)
            return original_win_valid(self) and window_has_terminal_buffer(self.win)
          end

          local original_is_open = terminal.is_open
          terminal.is_open = function(self)
            return original_is_open(self) and window_has_terminal_buffer(self.win)
          end

          local original_is_focused = terminal.is_focused
          terminal.is_focused = function(self)
            return self:win_valid() and original_is_focused(self)
          end

          local original_open_win = terminal.open_win
          terminal.open_win = function(self, ...)
            detach_stale_window()
            return original_open_win(self, ...)
          end

          local original_close = terminal.close
          terminal.close = function(self, ...)
            detach_stale_window()
            return original_close(self, ...)
          end

          vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
            group = terminal.group,
            callback = function()
              vim.schedule(detach_stale_window)
            end,
          })
        end,
        -- Allow the terminal split to act like a normie vim buffer
        wo = { winfixwidth = false, winfixheight = false },
        split = { width = 0, height = 0 },
      },
    },
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").focus()
      end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>asl",
      function()
        require("sidekick.cli").send({ msg = "{line}" })
      end,
      mode = "n",
      desc = "Send Line",
    },
    {
      "<leader>asl",
      function()
        require("sidekick.cli").send({ msg = "{position}" })
      end,
      mode = "x",
      desc = "Send Selection Reference",
    },
    {
      "<leader>asf",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      mode = "n",
      desc = "Send File",
    },
    {
      "<leader>ass",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = "x",
      desc = "Send Selection",
    },
    {
      "<leader>asv",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = "x",
      desc = "Send Visual Selection",
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Sidekick Close",
      mode = { "n", "t", "i", "x" },
    },
  },
}
