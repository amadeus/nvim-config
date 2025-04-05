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

local separators_config = {
  left = "",
  right = "",
}

local mode_config = {
  "mode",
  padding = 0,
  -- Print 3 letter shorthands for all modes
  fmt = function(name)
    local firstChar = string.sub(name, 1, 1)
    return " " .. firstChar .. " "
    -- local secondChar = string.sub(name, 2, 2)
    -- -- If the first character is not "V", return it with spaces around
    -- if firstChar ~= "V" or secondChar ~= '-' then
    --   return " " .. string.sub(name, 1, 3) .. " "
    -- end
    --
    -- local afterDash = string.sub(name, 3, 3)
    -- return " V:" .. afterDash .. " "
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
    -- vim.api.nvim_echo({ { '..'..str..'..' } }, true, {})
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
      return ""
    end
    return str
  end,
}

local filetype_component = {
  "filetype",
  colored = false,
  padding = {
    left = 1,
    right = 1,
  },
  fmt = function(str)
    if str == "codecompanion" then
      return ""
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
      return ""
    end
    return "[" .. str .. "]"
  end,
}

Evokai.terminal = Evokai.insert

local lsp_status_component = {
  "lsp_status",
  icon = "", -- f013
  symbols = {
    -- Standard unicode symbols to cycle through for LSP progress:
    spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    -- Standard unicode symbol for when LSP is done:
    done = "✓",
    -- Delimiter inserted between LSP names:
    separator = " ",
  },
  ignore_lsp = {},
}

return {
  "nvim-lualine/lualine.nvim",
  version = false,
  dependencies = { "rebelot/kanagawa.nvim" },
  init = function()
    vim.g.kanagawa_lualine_bold = true
  end,
  opts = {
    options = {
      theme = "kanagawa",
      icons_enabled = false,
      section_separators = separators_config,
      component_separators = separators_config,
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
    -- winbar = {
    --   lualine_c = { 'filename' },
    -- }
  },
}
