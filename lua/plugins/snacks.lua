local excluded_indent_buftypes = {
  terminal = true,
  quickfix = true,
  help = true,
  nofile = true,
  prompt = true,
}

local excluded_indent_filetypes = {
  startify = true,
  snacks_dashboard = true,
  git = true,
  gitcommit = true,
  fugitive = true,
  floggraph = true,
  markdown = true,
  diff = true,
  bigfile = true,
}

local dashboard_splash = "blackhole"
local dashboard_row_ratio = 0.35
local dashboard_recent_files_limit = 8

local function should_show_recent_file(file)
  local normalized = vim.fs.normalize(file)
  if normalized:find("COMMIT_EDITMSG", 1, true) or normalized:find(".DS_Store", 1, true) then
    return false
  end

  local runtime_doc = vim.fs.normalize(vim.env.VIMRUNTIME .. "/doc")
  if normalized:sub(1, #runtime_doc) == runtime_doc then
    return false
  end

  return not normalized:find("/bundle/.*/doc/")
end

local function get_dashboard_sessions()
  local cwd = vim.fn.getcwd()
  local session_files = {}
  local seen = {}

  for _, pattern in ipairs({ "Session.vim", "Session_*.vim" }) do
    for _, file in ipairs(vim.fn.globpath(cwd, pattern, false, true)) do
      local normalized = vim.fs.normalize(file)
      if not seen[normalized] and vim.fn.filereadable(normalized) == 1 then
        seen[normalized] = true
        table.insert(session_files, normalized)
      end
    end
  end

  table.sort(session_files)
  return session_files
end

local function dashboard_session_section()
  local session_files = get_dashboard_sessions()
  if #session_files == 0 then
    return nil
  end

  local section = {
    icon = "",
    title = "Sessions",
    indent = 3,
    padding = 1,
  }

  for _, file in ipairs(session_files) do
    table.insert(section, {
      desc = vim.fn.fnamemodify(file, ":t"),
      icon = "󰁯",
      action = function()
        vim.cmd("source " .. vim.fn.fnameescape(file))
      end,
    })
  end

  return section
end

local function count_dashboard_recent_files()
  local ok, dashboard = pcall(require, "snacks.dashboard")
  if not ok or type(dashboard) ~= "table" or type(dashboard.oldfiles) ~= "function" then
    return 0
  end

  local count = 0
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  for file in dashboard.oldfiles({ filter = { [cwd] = true } }) do
    if should_show_recent_file(file) then
      count = count + 1
      if count >= dashboard_recent_files_limit then
        break
      end
    end
  end
  return count
end

local function estimate_dashboard_height(header)
  local header_rows = header and #vim.split(header, "\n", { plain = true }) or 0
  local pane_one_height = header_rows + 2 + 1 -- header padding plus startup line

  local session_count = #get_dashboard_sessions()
  pane_one_height = pane_one_height + (session_count > 0 and session_count + 2 or 0)

  local recent_count = count_dashboard_recent_files()
  pane_one_height = pane_one_height + (recent_count > 0 and recent_count + 2 or 0)

  return pane_one_height
end

local function dashboard_row(header)
  local available_height = vim.api.nvim_win_get_height(0)
  local dashboard_height = estimate_dashboard_height(header)
  local free_height = math.max(available_height - dashboard_height, 0)

  return math.max(2, math.floor(free_height * dashboard_row_ratio))
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "amansingh-afk/milli.nvim",
    version = false,
    lazy = true,
  },
  ---@class snacks.scratch.Config
  opts = {
    dashboard = {
      enabled = true,
      width = 64,
      pane_gap = 6,
      config = function(opts)
        local ok, milli = pcall(require, "milli")
        local loaded, splash = false, nil
        if ok then
          loaded, splash = pcall(milli.load, { splash = dashboard_splash })
        end
        if ok and loaded and type(splash) == "table" then
          local frames = splash.frames
          local first_frame = type(frames) == "table" and frames[1] or nil
          if type(first_frame) == "table" then
            if type(opts.preset) ~= "table" then
              opts.preset = {}
            end
            opts.preset.header = table.concat(first_frame, "\n")
          end
        end

        local preset = opts.preset
        local header = type(preset) == "table" and type(preset.header) == "string" and preset.header or nil
        opts.row = dashboard_row(header)
      end,
      formats = {
        icon = function(item)
          if item.file and (item.icon == "file" or item.icon == "directory") then
            local icon = Snacks.dashboard.icon(item.file, item.icon)
            icon[1] = icon[1]:gsub("%s+$", "")
            icon.width = vim.api.nvim_strwidth(icon[1])
            return icon
          end

          local icon = (item.icon or ""):gsub("%s+$", "")
          return { icon, width = vim.api.nvim_strwidth(icon), hl = "icon" }
        end,
        file = function(item, ctx)
          local cwd = vim.fs.normalize(vim.fn.getcwd())
          local file = vim.fs.normalize(item.file)
          local fname = file:sub(1, #cwd + 1) == cwd .. "/" and file:sub(#cwd + 2) or vim.fn.fnamemodify(file, ":.")
          local width = ctx.width or 0

          if fname ~= "" and not fname:match("^/") and not fname:match("^%./") and not fname:match("^%.%./") then
            fname = "./" .. fname
          end

          if width > 0 and #fname > width then
            fname = vim.fn.pathshorten(fname)
          end
          if width > 0 and #fname > width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local name = vim.fn.fnamemodify(fname, ":t")
            if dir and name then
              name = name:sub(-(width - #dir - 2))
              fname = dir .. "/…" .. name
            end
          end

          local dir, name = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { name, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        { section = "header", padding = 1 },
        { key = "e", action = ":bd", hidden = true },
        { key = "gq", action = ":bd", hidden = true },
        { key = "o", action = ":Oil", hidden = true },
        { key = "U", action = ":Lazy update", hidden = true, enabled = package.loaded.lazy ~= nil },
        { key = "L", action = ":Lazy update", hidden = true, enabled = package.loaded.lazy ~= nil },
        dashboard_session_section,
        {
          icon = "",
          title = "Recent Files",
          section = "recent_files",
          cwd = true,
          indent = 3,
          limit = dashboard_recent_files_limit,
          padding = 1,
          filter = should_show_recent_file,
        },
        { section = "startup" },
      },
    },
    bigfile = {
      enabled = true,
      size = 0.5 * 1024 * 1024, -- 0.5mb
      notify = true,
      line_length = 1000,
    },
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },
    scratch = {
      title = "Scratch",
      ft = "markdown",
      filekey = {
        cwd = true,
        branch = false,
        count = false,
      },
      win = {
        keys = {
          q = false,
          gq = "close",
        },
      },
    },
    picker = {
      ui_select = true,
      jump = {
        reuse_win = true,
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      main = {
        current = true,
      },
      win = {
        input = {
          keys = {
            -- Ensure that escape allows us to quit the picker
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<c-s>"] = false,
            ["<c-x>"] = { "edit_split", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<c-s>"] = false,
            ["<c-x>"] = "edit_split",
          },
        },
      },
      layout = {
        preset = "dropdown",
        layout = {
          backdrop = false,
          width = 0.4,
          min_width = 80,
          height = 0.25,
          min_height = 10,
          border = "none",
          box = "vertical",
          {
            box = "vertical",
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
        },
      },
    },
    indent = {
      indent = {
        char = "╎",
        only_current = true,
      },
      -- This only controls the base line indent.
      -- Experimenting with it off
      scope = {
        enabled = false,
        char = "│",
        underline = false,
        only_current = true,
      },
      chunk = {
        enabled = true,
        only_current = true,
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = "▶",
        },
      },
      animate = {
        enabled = false,
        easing = "inOutSine",
        fps = 120,
        duration = {
          step = 1000 / 120,
          total = 400,
        },
      },
      filter = function(buf)
        if excluded_indent_buftypes[vim.bo[buf].buftype] or excluded_indent_filetypes[vim.bo[buf].filetype] then
          return false
        end
        return true
      end,
    },
    gh = {},
    gitbrowse = {},
    styles = {
      notification = {
        wo = { wrap = true },
        border = "rounded",
      },
      notification_history = {
        border = "solid",
      },
      scratch = {
        border = "rounded",
        minimal = true,
        backdrop = 10,
        wo = {
          statuscolumn = " ",
        },
      },
    },
    input = {
      win = {
        relative = "cursor",
        row = -3,
        col = 0,
        border = "rounded",
        keys = {
          i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
        },
      },
    },
  },
  config = function(_, opts)
    local ok, milli = pcall(require, "milli")
    if ok then
      milli.snacks({ splash = dashboard_splash, loop = true })
    end

    require("snacks").setup(opts)
  end,
  keys = {
    {
      "<leader>nh",
      function()
        require("snacks.notifier").show_history()
      end,
      desc = "Show Notification History",
    },
    {
      "<leader>sb",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>sB",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    -- Picker maps
    {
      "<leader>b",
      function()
        Snacks.picker.buffers({
          win = {
            input = {
              keys = {
                ["<c-x>"] = { "edit_split", mode = { "i" } },
                ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
              },
            },
          },
        })
      end,
      desc = "Buffers",
    },
    {
      "<leader>tb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>th",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>jd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "<leader>ji",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "<leader>fsh",
      function()
        Snacks.picker.highlights({ pattern = "hl_group:^Snacks" })
      end,
      nowait = true,
      desc = "Snacks Highlights",
    },
    {
      "<leader>ghi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>ghI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>ghp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>ghP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
  },
  init = function()
    -- Snacks hides global UI chrome on startup dashboards by default.
    -- Restore lualine and remove the built-in q binding in favor of e/gq.
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("snacks-dashboard-keys", { clear = true }),
      pattern = "SnacksDashboardOpened",
      callback = function()
        pcall(vim.api.nvim_buf_del_keymap, 0, "n", "q")
        vim.o.laststatus = 2
        pcall(function()
          vim.cmd("setlocal statusline<")
        end)
        pcall(function()
          require("lualine").refresh({ place = { "statusline" } })
        end)
      end,
    })

    vim.api.nvim_create_user_command("GB", function(opts)
      local line_start, line_end
      if opts.range > 0 then
        line_start = opts.line1
        line_end = opts.line2
      else
        line_start = vim.fn.line(".")
        line_end = line_start
      end

      Snacks.gitbrowse.open({
        line_start = line_start,
        line_end = line_end,
        what = "file",
      })
    end, {
      range = true,
      force = true,
      desc = "Open selection in github or related service",
    })

    ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd("LspProgress", {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
          return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
          if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
              token = ev.data.params.token,
              msg = ("[%3d%%] %s%s"):format(
                value.kind == "end" and 100 or value.percentage or 100,
                value.title or "",
                value.message and (" **%s**"):format(value.message) or ""
              ),
              done = value.kind == "end",
            }
            break
          end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
          return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
          id = "lsp_progress",
          title = client.name,
          opts = function(notif)
            notif.icon = #progress[client.id] == 0 and " "
              or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
          end,
        })
      end,
    })
  end,
}
