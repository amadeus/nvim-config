local spinner_symbols = { "⣽", "⣾", "⣷", "⣯", "⣟", "⡿", "⢿", "⣻" }

local Evokai = {
  normal = {
    a = { fg = "#085e0b", bg = "#49fd2f", gui = "bold" },
    b = { fg = "#efefef", bg = "#444444" },
    c = { fg = "#9e9e9e", bg = "#303030" },
  },
  insert = {
    a = { fg = "#0087dd", bg = "#ffffff", gui = "bold" },
    b = { fg = "#ffffff", bg = "#0087dd" },
  },
  visual = {
    a = { fg = "#ff4b00", bg = "#ffffff", gui = "bold" },
    b = { fg = "#ffffff", bg = "#ff4b00" },
  },
  replace = {
    a = { fg = "#ff027f", bg = "#ffffff", gui = "bold" },
    b = { fg = "#ffffff", bg = "#ff027f" },
  },
  inactive = {
    a = { fg = "#5f5f5f", bg = "#262622" },
    b = { fg = "#5f5f5f", bg = "#262622" },
    c = { fg = "#5f5f5f", bg = "#262622" },
  },
}

local mode_config = {
  "mode",
  padding = 1,
  -- Only print the first letter of the mode...
  fmt = function(name)
    return string.sub(name, 1, 1)
  end,
}

local function convertPath(input)
  local _, actualPath = input:match("^vaffle://(%d+)//(.*)")
  if actualPath then
    return "/" .. actualPath
  else
    return "Vaffle "
  end
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
    if vim.bo.filetype == "GV" then
      return "GV"
    end
    if string.match(str, "^fugitive:") then
      return "Fugitive "
    end
    if string.match(str, "^health:") then
      return "CheckHealth"
    end
    if string.match(str, "^%[CodeCompanion%]") then
      return "Claude Chat"
    end
    if string.match(str, "^vaffle:") then
      return convertPath(str)
    end
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
  end,
}

local branch_component = {
  "branch",
  separator = "",
  padding = {
    left = 1,
    right = 0,
  },
  fmt = function(str)
    if vim.bo.filetype == "codecompanion" then
      return nil
    end
    return str
  end,
}

local hidden_filetypes = {
  ["codecompanion"] = true,
  ["help"] = true,
  ["fugitive"] = true,
  ["gitcommit"] = true,
  ["vaffle"] = true,
  ["GV"] = true,
  ["startify"] = true,
}

local filetype_component = {
  "filetype",
  colored = false,
  padding = {
    left = 1,
    right = 1,
  },
  fmt = function(str)
    if hidden_filetypes[str] then
      return nil
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

local diff_component = { "dif" }

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

Evokai.terminal = Evokai.insert

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

local create_ai_spinner = function()
  local spinner = require("lualine.component"):extend()

  spinner.processing = false
  spinner.spinner_index = 1

  function spinner:init(options)
    spinner.super.init(self, options)

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionRequest*",
      group = group,
      callback = function(request)
        if request.match == "CodeCompanionRequestStarted" then
          self.processing = true
        elseif request.match == "CodeCompanionRequestFinished" then
          self.processing = false
        end
      end,
    })
  end

  -- Function that runs every time statusline is updated
  function spinner:update_status()
    if self.processing then
      self.spinner_index = (self.spinner_index % #spinner_symbols) + 1
      return spinner_symbols[self.spinner_index]
    else
      return nil
    end
  end
  return spinner
end

return {
  "nvim-lualine/lualine.nvim",
  version = false,
  dependencies = { "rebelot/kanagawa.nvim", "olimorris/codecompanion.nvim" },
  init = function()
    vim.g.kanagawa_lualine_bold = true
  end,
  opts = {
    options = {
      theme = "kanagawa",
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
        diff_component,
      },
      lualine_c = {
        branch_component,
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
        filename_component,
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
      lualine_b = {
        {
          "tabs",
          path = 0,
          mode = 1,
          tabs_color = {
            -- Same values as the general color option can be used here.
            active = "lualine_b_normal", -- Color for active tab.
            inactive = "lualine_c_inactive", -- Color for inactive tab.
          },
          symbols = {
            modified = "+", -- Text to show when the file is modified.
          },
        },
      },
    },
  },

  config = function(_, opts)
    local CodeCompanionSpinner = create_ai_spinner()
    table.insert(opts.sections.lualine_y, { CodeCompanionSpinner })
    require("lualine").setup(opts)
  end,
}
