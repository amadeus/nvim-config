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
  str = str:gsub(" New$", "")
  return str
end

local function convertPath(input)
  local path = input:match("^vaffle://[%d]+//(.*)") or input:match("^v//[%d]+//(.*)")
  path = trimSymbol(path)
  return path and ("/" .. path) or "Vaffle"
end

local filename_component = {
  "filename",
  path = 1,
  symbols = {
    modified = "+",
    readonly = "×",
    unnamed = "",
    newfile = "New",
  },
  padding = {
    left = 1,
    right = 1,
  },
  fmt = function(str)
    -- Special case handling of specific buffers
    if vim.bo.filetype == "startify" then
      return nil
    end
    if vim.bo.filetype == "GV" then
      return "GV"
    end
    if vim.bo.filetype == "git" or string.match(str, "^%.git/") then
      return "Git"
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
  end,
}

local filename_inactive_component = vim.tbl_extend("force", {}, filename_component)
filename_inactive_component.color = {
  bg = "#16161e",
  fg = "#3b4261",
}

local branch_component = {
  "branch",
  separator = "",
  padding = {
    left = 1,
    right = 0,
  },
  fmt = function(str)
    if hidden_filetypes[vim.bo.filetype] then
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
    return "⊙"
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

local tabs_component = {
  "buffers",
  section_separators = { left = "", right = "" },
  component_separators = { left = "", right = "" },
  tabs_component = "",
  mode = 0,
  show_filename_only = false,
  show_modified_status = true,
  max_length = vim.o.columns,
  symbols = {
    modified = " +", -- Text to show when the buffer is modified
    alternate_file = "", -- Text to show to identify the alternate file
    directory = "", -- Text to show when the buffer is a directory
  },
  filetype_names = {
    TelescopePrompt = "Telescope",
    dashboard = "Dashboard",
    packer = "Packer",
    fzf = "FZF",
    alpha = "Alpha",
  }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
  buffers_color = {
    active = {
      bg = "#7aa2f7",
      fg = "#15161e",
      gui = "bOld",
    },
    inactive = {
      fg = "#3b4261",
      bg = "#15161e",
    },
  },
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

return {
  "nvim-lualine/lualine.nvim",
  version = false,
  dependencies = { "rebelot/kanagawa.nvim", "olimorris/codecompanion.nvim" },
  opts = {
    options = {
      theme = "tokyonight-night",
      icons_enabled = false,
      always_show_tabline = false,
    },
    sections = {
      lualine_a = {
        mode_config,
      },
      lualine_b = {
        selection_component,
        filename_component,
      },
      lualine_c = {
        branch_component,
        diff_component,
      },
      lualine_x = {
        filetype_component,
      },
      lualine_y = {},
      lualine_z = {
        diagnostics_component,
      },
    },
    -- INACTIVE BUFFER
    inactive_sections = {
      lualine_a = {},
      lualine_b = {
        filename_inactive_component,
        diff_component,
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        diagnostics_component,
      },
    },
    tabline = {
      lualine_a = {},
      lualine_b = { tabs_component },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },

  config = function(_, opts)
    local code_companion = require("config.lualine-ai-spinner")
    local lsp_status = require("config.lualine-lsp-status")
    table.insert(opts.sections.lualine_y, { lsp_status })
    table.insert(opts.sections.lualine_y, { code_companion })
    require("lualine").setup(opts)
  end,
}
