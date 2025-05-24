local spinner_symbols = { "⣽", "⣾", "⣷", "⣯", "⣟", "⡿", "⢿", "⣻" }

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
  local pattern = " \226\151\143$"
  str = str:gsub(pattern, "")
  str = str:gsub(" New$", "")
  return str
end

local function convertPath(input)
  local path = input:match("^vaffle://[%d]+//(.*)") or input:match("^v//[%d]+//(.*)")
  path = trimSymbol(path)
  return path and ("/" .. path) or "Vaffle"
end

local function getFilenameStr(str)
  -- Special case handling of specific buffers
  if vim.bo.filetype == "startify" then
    return nil
  end
  if vim.bo.filetype == "Avante" then
    return "Avante Chat"
  end
  if vim.bo.filetype == "GV" then
    return nil
  end
  if vim.bo.filetype == "git" or string.match(str, "^%.git/") then
    return nil
  end
  if string.match(str, "^term:") or string.match(str, "^t//") then
    return "Terminal"
  end
  if string.match(str, "^fugitive:") or string.match(str, "^f//") then
    return "Fugitive"
  end
  if string.match(str, "^health:") then
    return "CheckHealth"
  end
  if string.match(str, "^%[CodeCompanion%]") then
    return "Claude Chat"
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
    readonly = "⊘",
    unnamed = "",
    newfile = "New",
  },
  padding = {
    left = 1,
    right = 1,
  },
  fmt = getFilenameStr,
  -- NOTE: Probably not needed, but keeping around just in case there are
  -- situations where E36 are triggered...
  -- fmt = function(str)
  --   local win_id = vim.api.nvim_get_current_win()
  --   local win_width = vim.api.nvim_win_get_width(win_id)
  --   local message = "win_id: " .. win_id .. ", win_width: " .. win_width
  --   -- vim.api.nvim_echo({ { message } }, true, {})
  --   local filename = getFilenameStr(str)
  --   if filename then
  --     local max_len = win_width - 2
  --     local actual_len = #filename
  --     if actual_len > max_len and max_len > 0 then
  --       filename = "…" .. string.sub(filename, actual_len - max_len - 10)
  --     end
  --     return filename
  --   end
  --   return ""
  -- end,
  cond = function()
    local buftype = vim.bo.buftype
    local is_modifiable = vim.bo.modifiable
    local is_buflisted = vim.bo.buflisted
    local buf_name = vim.fn.bufname(0)

    -- Disable all the shit for :Goyo
    if vim.fn.exists("t:goyo_master") == 1 then
      return false
    end

    -- Disable for non-buffers
    if
      buftype == "nofile"
      and is_modifiable == false
      and is_buflisted == false
      and (buf_name == nil or buf_name == "")
    then
      return false
    end

    -- Disable for terminal and quickfix
    if buftype == "terminal" or buftype == "quickfix" then
      return false
    end

    return true
  end,
}

local filename_inactive_component = vim.tbl_extend("force", {}, filename_component)
filename_inactive_component.color = {
  bg = "#16161e",
  fg = "#3b4261",
}

local hidden_filetypes_branch = {
  ["checkhealth"] = true,
  ["codecompanion"] = true,
  ["help"] = true,
  ["vaffle"] = true,
  ["GV"] = true,
}

local branch_component = {
  "branch",
  separator = "",
  fmt = function(str)
    if hidden_filetypes_branch[vim.bo.filetype] or vim.bo.buftype == "terminal" then
      return nil
    end
    return str
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
  diagnostics_color = {
    -- FIXME: Make these colors use tokyonight colors
    error = { fg = "#ffffff", bg = "#e60000" },
    warn = { fg = "#000000", bg = "#fff600" },
  },
}

local diff_component = {
  "diff",
  fmt = function(str)
    if not str or not str:match("%S") then
      return nil
    end
    return "±"
  end,
  color = { fg = "#e0af68" }, -- Custom color for the whole component
}

local selection_component = {
  "selectioncount",
  padding = {
    left = 1,
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

---@diagnostic disable-next-line: unused-local
local lsp_status_component = {
  "lsp_status",
  icon = "", -- f013
  symbols = {
    spinner = spinner_symbols,
    done = "✓",
    separator = " ",
  },
  ignore_lsp = {
    "eslint",
    "copilot",
    "cssmodules_ls",
  },
}

local default_sections = {
  lualine_a = { mode_config },
  lualine_b = { selection_component, branch_component },
  lualine_c = { diff_component },
  lualine_x = { filetype_component },
  lualine_y = {},
  lualine_z = { diagnostics_component },
}

local tabs_component = {
  "tabs",
  -- Allow the tabs component to take up the full window width
  max_length = vim.o.columns,
  section_separators = { left = "", right = "" },
  component_separators = { left = "", right = "" },
  mode = 0,
  path = 0,
  use_mode_colors = true,
  symbols = { modified = " •" },
}

return {
  "nvim-lualine/lualine.nvim",
  version = false,
  dependencies = { "rebelot/kanagawa.nvim", "olimorris/codecompanion.nvim" },
  opts = {
    globalstatus = true,
    options = {
      theme = "tokyonight-night",
      icons_enabled = false,
      always_show_tabline = false,
      disabled_filetypes = {
        winbar = { "fugitive", "gitcommit", "AvanteSelectedFiles", "AvanteInput" },
      },
    },
    sections = default_sections,
    -- We need to make inactive identical to active because of laststatus = 3,
    -- otherwise there can be weird flicker that occurs
    inactive = default_sections,
    tabline = {
      lualine_a = { tabs_component },
    },
    winbar = {
      lualine_b = { filename_component },
    },
    inactive_winbar = {
      lualine_c = { filename_component },
    },
    refresh = {
      statusline = 1000 / 120,
      tabline = 100,
      winbar = 100,
    },
  },

  init = function()
    vim.opt.laststatus = 3
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
    custom_tokyonight.normal.c.bg = "#0C0E14"
    opts.options.theme = custom_tokyonight

    -- Hide lualine when using Goyo
    vim.api.nvim_create_autocmd("User", {
      pattern = "GoyoEnter",
      callback = function()
        ---@diagnostic disable-next-line: missing-fields
        lualine.hide({ unhide = false })
        vim.opt.signcolumn = "no"
      end,
    })
    vim.api.nvim_create_autocmd("User", {
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
