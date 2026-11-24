local hidden_filetypes = {
  ["checkhealth"] = true,
  ["help"] = true,
  ["fugitive"] = true,
  ["gitcommit"] = true,
  ["git"] = true,
  ["snacks_dashboard"] = true,
  ["gents_terminal"] = true,
  ["DiffviewFiles"] = true,
  ["DiffviewFileHistory"] = true,
}

local diffview_labels = {
  ["DiffviewFiles"] = "Files",
  ["DiffviewFileHistory"] = "History",
}

local function is_gents_terminal()
  return vim.bo.buftype == "terminal" and vim.bo.filetype == "gents_terminal"
end

local function get_gents_label()
  if not is_gents_terminal() then
    return nil
  end

  local session = require("gents").current()
  return session and session.label:gsub("^opencode", "OpenCode"):gsub("^%l", string.upper) or "Gents"
end

local mode_config = {
  "mode",
  padding = 1,
  fmt = function(name)
    if is_gents_terminal() then
      return " "
    end
    if diffview_labels[vim.bo.filetype] then
      return " "
    end
    -- Only print the first letter of the mode...
    return string.sub(name, 1, 1)
  end,
}

local function format_diffview_filename(bufname)
  local revision, path = bufname:match("/(%x%x%x%x%x%x%x%x%x%x%x)/(.+)$")
  if revision then
    return revision:sub(1, 5) .. ":" .. path
  end

  local stage
  stage, path = bufname:match("/:(%d):/(.+)$")
  if stage then
    local label = stage == "0" and "index" or ("stage " .. stage)
    return label .. ":" .. path
  end
end

-- NUL cannot occur in a path or branch. These marks survive lualine's formatting
-- and are removed before the statusline reaches Neovim.
local function mark_shortenable(text)
  return text:find("/", 1, true) and ("\0" .. text .. "\0") or text
end

local function getFilenameStr(str, fit_path)
  local bufname = vim.api.nvim_buf_get_name(0)
  if vim.startswith(bufname, "diffview://") then
    local diffview_filename = format_diffview_filename(bufname)
    if diffview_filename then
      return (diffview_filename:gsub("%%", "%%%%"))
    end
  end

  -- Special case handling of specific buffers
  if vim.bo.filetype == "snacks_dashboard" then
    return "Sup Bisch"
  end
  if vim.bo.filetype == "canola" and package.loaded.canola then
    local canola = require("canola")
    local ok, dir = pcall(canola.get_current_dir)
    if ok and dir and dir ~= "" then
      return (vim.fn.fnamemodify(dir, ":~"):gsub("%%", "%%%%"))
    end
  end
  -- Special case handling for commit messages
  local pattern_to_find = "%.git/COMMIT_EDITMSG"
  local new_string, num_matches = string.gsub(str, pattern_to_find, "Commit Message", 1)
  if num_matches > 0 then
    return new_string
  end
  -- fugitive buffers should be treated as such
  if vim.bo.filetype == "fugitive" then
    return "Git Status"
  end
  if vim.bo.filetype == "git" or string.match(str, "^fugitive:") or string.match(str, "^f//") then
    return "Fugitive"
  end
  if vim.bo.buftype == "terminal" then
    return "[Term] " .. vim.api.nvim_get_current_buf()
  end
  if string.match(str, "^health:") then
    return "CheckHealth"
  end
  local path = vim.trim(str)
  return fit_path and mark_shortenable(path) or path
end

local gents_filename_component = {
  function()
    return get_gents_label()
  end,
  padding = {
    left = 1,
    right = 1,
  },
  cond = function()
    return is_gents_terminal()
  end,
}

local gents_title_component = {
  function()
    local session = require("gents").current()
    return (session and session.title or "Untitled"):gsub("%%", "%%%%")
  end,
  padding = 1,
  cond = function()
    return vim.bo.buftype == "terminal" and vim.bo.filetype == "gents_terminal"
  end,
}

local diffview_inactive_filename_component = {
  function()
    return diffview_labels[vim.bo.filetype]
  end,
  padding = {
    left = 1,
    right = 1,
  },
  cond = function()
    return diffview_labels[vim.bo.filetype] ~= nil
  end,
}

local filename_component = {
  "filename",
  path = 1,
  symbols = {
    modified = "•",
    readonly = "",
    unnamed = "",
    newfile = "New",
  },
  padding = {
    left = 1,
    right = 1,
  },
  fmt = function(str)
    return getFilenameStr(str)
  end,
  cond = function()
    -- Disable all the shit for :Goyo
    if vim.fn.exists("t:goyo_master") == 1 then
      return false
    end
    if diffview_labels[vim.bo.filetype] then
      return false
    end
    return not is_gents_terminal()
  end,
}

local hidden_filetypes_branch = {
  ["checkhealth"] = true,
  ["help"] = true,
}

local active_filename_component = vim.tbl_extend("force", filename_component, {
  shorting_target = 0,
  fmt = function(str)
    return getFilenameStr(str, true)
  end,
})

local branch_component = {
  function()
    if is_gents_terminal() then
      return get_gents_label()
    end
    local filetype = vim.bo.filetype
    if diffview_labels[filetype] then
      return diffview_labels[filetype]
    end
    local is_commit_message = filetype == "gitcommit"
    if
      (not is_commit_message and vim.api.nvim_win_get_width(0) <= 80)
      or hidden_filetypes_branch[filetype]
      or vim.bo.buftype == "terminal"
    then
      return ""
    end
    local gitsigns = vim.b.gitsigns_status_dict
    local branch = vim.b.gitsigns_head or (gitsigns and gitsigns.head) or ""
    if is_commit_message and branch == "" and vim.fn.exists("*FugitiveHead") == 1 then
      branch = vim.fn.FugitiveHead(7)
    end
    return branch ~= "" and " " .. mark_shortenable(branch:gsub("%%", "%%%%")) or ""
  end,
}

local function shorten_field(field, needed)
  if needed <= 0 then
    return field, 0
  end
  local saved = 0
  local initials = {}
  local start = 1
  while saved < needed do
    local slash = field:find("/", start, true)
    if not slash then
      break
    end
    local prefix = field:sub(start, slash - 1):gsub("%%%%", "%%")
    local count = prefix:sub(1, 1) == "." and 2 or 1
    local initial
    if prefix:find("[^ -~]") then
      initial = vim.fn.strcharpart(prefix, 0, count, 1)
      saved = saved + vim.api.nvim_strwidth(prefix) - vim.api.nvim_strwidth(initial)
    else
      initial = prefix:sub(1, count)
      saved = saved + #prefix - #initial
    end
    initials[#initials + 1] = initial:gsub("%%", "%%%%")
    start = slash + 1
  end
  initials[#initials + 1] = field:sub(start)
  return table.concat(initials, "/"), saved
end

local function fit_statusline(line)
  if not line or not line:find("\0", 1, true) then
    return line
  end
  local full = line:gsub("%z", "")
  -- maxwidth=0 measures the content without clipping or filling the %= spacer.
  local overflow = vim.api.nvim_eval_statusline(full, { maxwidth = 0 }).width - vim.api.nvim_win_get_width(0)
  if overflow <= 0 then
    return full
  end

  -- Lualine emits the branch first. Only shorten directories for the overflow it leaves.
  return (
    line:gsub("%z([^%z]*)%z", function(field)
      local shortened, saved = shorten_field(field, overflow)
      overflow = overflow - saved
      return shortened
    end)
  )
end

local filetype_abbr = {
  ["typescript"] = "ts",
  ["typescriptreact"] = "tsx",
  ["typescript.tsx"] = "tsx",
  ["javascript"] = "js",
  ["javascriptreact"] = "jsx",
  ["javascript.tsx"] = "jsx",
}

local filetype_component = {
  "filetype",
  icons_enabled = false,
  padding = {
    left = 1,
    right = 1,
  },
  fmt = function(str)
    if hidden_filetypes[str] then
      return nil
    end
    if filetype_abbr[vim.bo.filetype] then
      return filetype_abbr[vim.bo.filetype]
    end
    return str
  end,
}

local diagnostics_component = {
  "diagnostics",
  sections = { "error", "warn" },
  colored = true,
}

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local diff_component = {
  "diff",
  padding = { left = 0, right = 1 },
  source = diff_source,
}

local diff_inactive_component = vim.tbl_extend("force", {}, diff_component)

local selection_component = {
  "selectioncount",
  padding = {
    left = 0,
    right = 0,
  },
  separator = "",
  fmt = function(str)
    if str == nil or str == "" then
      return nil
    end
    return "[" .. str .. "]"
  end,
}

local default_sections = {
  lualine_a = { mode_config, selection_component },
  lualine_b = { branch_component },
  lualine_c = { gents_title_component, active_filename_component, diff_component },
  lualine_x = { filetype_component },
  lualine_y = {},
  lualine_z = { diagnostics_component },
}

local default_inactive = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {
    gents_filename_component,
    diffview_inactive_filename_component,
    filename_component,
    diff_inactive_component,
  },
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

local diffview_tab_labels = {
  DiffView = "Diff",
  FileHistoryView = "File History",
  FileDiffView = "File Diff",
  FileDirDiffView = "Directory Diff",
  FileMergeView = "Merge",
}

local function is_flog_tab(tabpage)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "floggraph" then
      return true
    end
  end
  return false
end

local function get_diffview_tab_label(tabpage)
  local diffview = package.loaded["diffview.lib"]
  if not diffview then
    return nil
  end

  local view = diffview.tabpage_to_view(tabpage)
  if not view then
    return nil
  end

  return diffview_tab_labels[view.class.__name] or "Diff Files"
end

local tabs_component = {
  "tabs",
  max_length = function()
    return vim.o.columns
  end,
  -- section_separators = { left = "", right = "" },
  -- component_separators = { left = "", right = "" },
  mode = 1,
  path = 0,
  use_mode_colors = true,
  symbols = { modified = "•" },
  padding = { right = 2, left = 2 },
  fmt = function(name, context)
    local tabname = context and context.tabId and vim.t[context.tabId].tabname
    if tabname and tabname ~= "" then
      return name
    end
    if context and context.tabId and vim.t[context.tabId].zoom then
      return "Zoom"
    end
    if context and context.tabId and is_flog_tab(context.tabId) then
      return "Flog"
    end
    local diffview_label = context and context.tabId and get_diffview_tab_label(context.tabId)
    if diffview_label then
      return diffview_label
    end
    if context and context.tabnr then
      return "Workspace " .. tostring(context.tabnr)
    end
    return name
  end,
}

local render_statusline

return {
  "nvim-lualine/lualine.nvim",
  version = false,
  opts = {
    options = {
      section_separators = { left = "", right = "" },
      -- component_separators = { left = "│", right = "│" },
      component_separators = { left = "", right = "" },
      theme = "tokyonight-night",
      icons_enabled = true,
      always_show_tabline = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
        refresh_time = 100,
      },
    },
    sections = default_sections,
    inactive_sections = default_inactive,
    tabline = { lualine_a = { tabs_component } },
  },

  config = function(_, opts)
    local lualine = require("lualine")
    local lsp_status = require("config.lualine-lsp-status")
    table.insert(opts.sections.lualine_y, { lsp_status })

    -- Some colors I manually pulled from the tokyonight-night color reference
    -- file I have. For the inactive buffer colors, I just took the values and
    -- manually tweaked them...
    diagnostics_component.diagnostics_color = {
      error = { fg = "#ffffff", bg = "#ff007c" },
      warn = { fg = "#000000", bg = "#ff9e64" },
    }

    diff_inactive_component.diff_color = {
      added = { fg = "#384d22" },
      modified = { fg = "#2d485b" },
      removed = { fg = "#522d39" },
    }

    local lualine_group = vim.api.nvim_create_augroup("lualine-group", { clear = true })
    -- Hide lualine when using Goyo
    vim.api.nvim_create_autocmd("User", {
      group = lualine_group,
      pattern = "GoyoEnter",
      callback = function()
        ---@diagnostic disable-next-line: missing-fields
        lualine.hide({ unhide = false })
        vim.opt.signcolumn = "no"
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = lualine_group,
      pattern = "GoyoLeave",
      callback = function()
        ---@diagnostic disable-next-line: missing-fields
        lualine.hide({ unhide = true })
        vim.opt.signcolumn = "yes"
      end,
    })

    render_statusline = render_statusline or lualine.statusline
    lualine.statusline = function(...)
      return fit_statusline(render_statusline(...))
    end

    -- Finally run setup, lol
    lualine.setup(opts)
  end,
}
