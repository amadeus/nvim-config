local excluded_indent_buftypes = {
  terminal = true,
  quickfix = true,
  help = true,
  nofile = true,
  prompt = true,
}

local excluded_indent_filetypes = {
  startify = true,
  git = true,
  gitcommit = true,
  floggraph = true,
  markdown = true,
  diff = true,
  bigfile = true,
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@class snacks.scratch.Config
  opts = {
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
      formatters = {
        file = {
          filename_first = true,
        },
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
      scope = {
        enabled = true,
        char = "│",
        underline = false,
        only_current = true,
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
        border = "solid",
        minimal = true,
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
