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

---@diagnostic disable-next-line: unused-local
local function getFilenameStr(str, context)
  local bufname = vim.api.nvim_buf_get_name(0)
  if vim.startswith(bufname, "diffview://") then
    local diffview_filename = format_diffview_filename(bufname)
    if diffview_filename then
      return diffview_filename
    end
  end

  -- Special case handling of specific buffers
  if vim.bo.filetype == "snacks_dashboard" then
    return "Sup Bisch"
  end
  if vim.bo.filetype == "oil" and package.loaded.oil then
    local oil = require("oil")
    local ok, dir = pcall(oil.get_current_dir)
    if ok and dir and dir ~= "" then
      return vim.fn.fnamemodify(dir, ":~")
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
  return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
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
  fmt = getFilenameStr,
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

local branch_component = {
  function()
    if is_gents_terminal() then
      return get_gents_label()
    end
    if diffview_labels[vim.bo.filetype] then
      return diffview_labels[vim.bo.filetype]
    end
    local gitsigns = vim.b.gitsigns_status_dict
    local branch = vim.b.gitsigns_head or (gitsigns and gitsigns.head)
    if branch == nil or branch == "" then
      return ""
    end
    return " " .. branch
  end,
  fmt = function(str)
    if is_gents_terminal() then
      return str
    end
    if hidden_filetypes_branch[vim.bo.filetype] or vim.bo.buftype == "terminal" then
      return ""
    end
    return str
  end,
  -- Hide branch component when window gets too narrow to prioritize filename
  cond = function()
    if is_gents_terminal() or diffview_labels[vim.bo.filetype] then
      return true
    end
    return vim.fn.winwidth(0) > 80
  end,
}

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
  lualine_c = { gents_title_component, filename_component, diff_component },
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
        statusline = 100,
        tabline = 100,
      },
    },
    sections = default_sections,
    inactive_sections = default_inactive,
    tabline = { lualine_a = { tabs_component } },
  },

  config = function(_, opts)
    local lualine = require("lualine")
    local code_companion = require("config.lualine-ai-spinner")
    local lsp_status = require("config.lualine-lsp-status")
    table.insert(opts.sections.lualine_y, { lsp_status })
    table.insert(opts.sections.lualine_y, { code_companion })

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

    -- Finally run setup, lol
    lualine.setup(opts)
  end,
}
