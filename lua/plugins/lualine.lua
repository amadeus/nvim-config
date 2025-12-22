local hidden_filetypes = {
  ["checkhealth"] = true,
  ["codecompanion"] = true,
  ["help"] = true,
  ["fugitive"] = true,
  ["gitcommit"] = true,
  ["vaffle"] = true,
  ["GV"] = true,
  ["git"] = true,
  ["startify"] = true,
  ["Mundo"] = true,
  ["MundoDiff"] = true,
}

local mode_config = {
  "mode",
  padding = 1,
  -- Only print the first letter of the mode...
  fmt = function(name)
    return string.sub(name, 1, 1)
  end,
}

local function trimSymbol(str)
  str = str:gsub(" ×$", "")
  str = str:gsub(" +$", "")
  -- local pattern = " \226\151\143$"
  local pattern = " —$"
  str = str:gsub(pattern, "")
  str = str:gsub(" New$", "")
  return str
end

local function convertPath(input)
  local path = input:match("^vaffle://[%d]+//(.*)") or input:match("^v//[%d]+//(.*)")
  path = trimSymbol(path)
  return path and ("/" .. path) or "Vaffle"
end

---@diagnostic disable-next-line: unused-local
local function getFilenameStr(str, context)
  if vim.bo.filetype == "Mundo" then
    return "Mundo Tree"
  end
  if vim.bo.filetype == "MundoDiff" then
    return "Mundo Diff"
  end
  -- Special case handling of specific buffers
  if vim.bo.filetype == "startify" then
    return "Sup Bisch"
  end
  if vim.bo.filetype == "Avante" then
    return "Avante Chat"
  end
  if vim.bo.filetype == "oil" and package.loaded.oil then
    local oil = require("oil")
    local ok, dir = pcall(oil.get_current_dir)
    if ok and dir and dir ~= "" then
      return vim.fn.fnamemodify(dir, ":~")
    end
  end
  if vim.bo.filetype == "GV" then
    return "GV"
  end
  -- Special case handling for commit messages
  local pattern_to_find = "%.git/COMMIT_EDITMSG"
  local new_string, num_matches = string.gsub(str, pattern_to_find, "Commit Message", 1)
  if num_matches > 0 then
    return new_string
  end
  -- fugitive buffers should be treated as such
  if vim.bo.filetype == "git" or string.match(str, "^fugitive:") or string.match(str, "^f//") then
    return "Fugitive"
  end
  if string.match(str, "^term:") or string.match(str, "^t//") then
    return "Terminal"
  end
  if string.match(str, "^health:") then
    return "CheckHealth"
  end
  if string.match(str, "^vaffle:") or string.match(str, "^v//") then
    return convertPath(str)
  end
  return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

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
    return true
  end,
}

local hidden_filetypes_branch = {
  ["checkhealth"] = true,
  ["codecompanion"] = true,
  ["help"] = true,
  ["vaffle"] = true,
  ["GV"] = true,
  ["Mundo"] = true,
  ["MundoDiff"] = true,
}

---@diagnostic disable-next-line: unused-local
local old_branch_component = {
  "branch",
  separator = "",
  fmt = function(str)
    if hidden_filetypes_branch[vim.bo.filetype] or vim.bo.buftype == "terminal" then
      return nil
    end
    return str
  end,
}

local branch_component = {
  "FugitiveHead",
  icon = "",
  fmt = function(str)
    if hidden_filetypes_branch[vim.bo.filetype] or vim.bo.buftype == "terminal" then
      return nil
    end
    return str
  end,
  -- Hide branch component when window gets too narrow to prioritize filename
  cond = function()
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
  lualine_c = { filename_component, diff_component },
  lualine_x = { filetype_component },
  lualine_y = {},
  lualine_z = { diagnostics_component },
}

local default_inactive = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { filename_component, diff_inactive_component },
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

---@diagnostic disable-next-line: unused-local
local tabs_spacer = {
  function()
    return "  "
  end,
  color = { bg = "#16161e" },
  padding = 0,
  separator = "",
}

local tabs_component = {
  "tabs",
  max_length = vim.o.columns,
  -- section_separators = { left = "", right = "" },
  -- component_separators = { left = "", right = "" },
  mode = 1,
  path = 0,
  use_mode_colors = true,
  symbols = { modified = "•" },
  padding = { right = 2, left = 2 },
  fmt = function(name, context)
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
      disabled_filetypes = {
        statusline = { "AgenticChat", "AgenticCode", "AgenticFiles" },
        winbar = {
          "fugitive",
          "gitcommit",
          "AvanteSelectedFiles",
          "AvanteInput",
          "AgenticChat",
          "AgenticInput",
          "AgenticCode",
          "AgenticFiles",
        },
      },
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
      },
    },
    sections = default_sections,
    inactive_sections = default_inactive,
    tabline = { lualine_a = { tabs_component } },
  },

  init = function()
    vim.opt.laststatus = 2
  end,

  config = function(_, opts)
    local lualine = require("lualine")
    local code_companion = require("config.lualine-ai-spinner")
    local lsp_status = require("config.lualine-lsp-status")
    table.insert(opts.sections.lualine_y, { lsp_status })
    table.insert(opts.sections.lualine_y, { code_companion })

    -- Lets force the default bg of the status line to be darker, a value that
    -- better matches the win separator color i use
    local custom_tokyonight = require("lualine.themes.tokyonight-night")
    opts.options.theme = custom_tokyonight

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

    local lualine_group = vim.api.nvim_create_augroup("lualine-grou", { clear = true })
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
