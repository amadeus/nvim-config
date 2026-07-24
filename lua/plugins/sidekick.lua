local function sidekick_win_get_var(win, name)
  local ok, value = pcall(vim.api.nvim_win_get_var, win, name)
  if ok then
    return value
  end
end

local function sidekick_is_buffer(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  return vim.bo[buf].filetype == "sidekick_terminal" or vim.b[buf].sidekick_cli ~= nil
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

local function sidekick_setup_equalize()
  local group = vim.api.nvim_create_augroup("sidekick_equalize", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "SidekickCliShow",
    desc = "Equalize window sizes when the Sidekick terminal opens",
    command = "wincmd =",
  })
end

local function sidekick_init()
  sidekick_setup_notifications()
  sidekick_setup_equalize()
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
