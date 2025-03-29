-- require('nvim-web-devicons').setup {
--   color_icons = true;
--   -- globally enable default icons (default to false)
--   -- will get overriden by `get_icons` option
--   default = true;
-- }

require("mason").setup()

local lspconfig = require("mason-lspconfig")
lspconfig.setup({capabilities})
lspconfig.setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      -- Disable semantic tokens/highlighting from LSP
      semanticTokensProvider = false,
      -- Alternatively, you can use this setting which is more commonly supported
      on_attach = function(client, bufnr)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end
    })
  end,
}

-- lspconfig.lua_ls.setup({
--   settings = {
--     Lua = {
--       runtime = {
--         -- Set Lua runtime version
--         version = "LuaJIT",
--       },
--       diagnostics = {
--         -- Recognize 'vim' as a global
--         globals = { "vim" },
--       },
--       workspace = {
--         -- Include Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--       },
--       telemetry = {
--         -- Disable telemetry
--         enable = false,
--       },
--     },
--   },
-- })

local blink_cmp = require('blink.cmp')
-- Configure blink.cmp
blink_cmp.setup({
  keymap = {
    preset = 'default',
    ['<C-n>'] = { 'show', 'select_next', 'fallback' },
    ['<C-k>'] = { 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono'
  },

  -- Default list of enabled providers
  completion = {
    list = {
      selection = {
        preselect = false,
      }
    },
    trigger = {
      show_on_keyword = true,
      show_on_trigger_character = true;
      show_on_blocked_trigger_characters = {},
      -- show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
    },
    accept = {
      -- A way to fix neovide cursor animations
      dot_repeat = false,
    },
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind', 'source_id', gap = 1 },
        },
      },
    },
  },

  cmdline = {
    -- This seems to build grepper for some reason :thonk:
    -- enabled = false,
    keymap = {
      preset = 'cmdline',
      ['<tab>'] = { 'select_and_accept' },
      ['<left>'] = { 'fallback' },
      ['<right>'] = { 'fallback' },
    },
    -- Doesn't appear to do anything...
    -- sources = function()
    --   local type = vim.fn.getcmdtype()
    --   -- Search forward and backward
    --   if type == '/' or type == '?' then return { 'buffer' } end
    --   -- Commands
    --   if type == ':' or type == '@' then return { 'cmdline' } end
    --   return {}
    -- end,
    completion = {
      list = {
        selection = {
          preselect = false,
        },
      },
      menu = {
        auto_show = true,
      },
    },
  },

  sources = {
    default = { 'lsp', 'path', 'buffer' },
    -- Appears to be broken at the moment, see: https://github.com/Saghen/blink.cmp/issues/836
    -- providers = {
    --   lsp = {
    --     override = {
    --       get_trigger_characters = function(self)
    --         local trigger_characters = self:get_trigger_characters()
    --         vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
    --         return trigger_characters
    --       end
    --     },
    --   },
    -- },
  },

  -- Experimental signature help support
  signature = {
    enabled = true,
    window = {
      border = 'none',
    },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" }
})



require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "query",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true,
    disable = {}
  },
  -- incremental_selection = {enable = true},
  textobjects = {enable = true},
  -- autotag = {
  --   enable = true
  -- }

  -- playground = {
  --   enable = true,
  --   disable = {},
  --   updatetime = 25,
  --   persist_queries = false,
  -- }
}

-- require('ayu').setup({
--   mirage = true,
--   overrides = {
--     Normal = { bg = "None" },
--     -- CursorColumn = { bg = "None" },
--     -- CursorLine = { style = '' },
--     SignColumn = { bg = "None" },
--     EndOfBuffer = { fg = "#0f1419" },
--   }
-- })

-- local function remove_underline()
--   local groups_to_update = {
--     'DiffAdd',
--     'DiffChange',
--     'DiffDelete',
--     'DiffText',
--   }
--   for _, group in ipairs(groups_to_update) do
--     vim.api.nvim_set_hl(0, group, { underline = false })
--   end
-- end
-- remove_underline();

-- Hardcoded theme from what I had prior...
local Evokai = {
  normal = {
    a = { fg = '#085e0b', bg = '#49fd2f', gui = 'bold' },
    b = { fg = '#efefef', bg = '#444444' },
    c = { fg = '#9e9e9e', bg = '#303030' },
  },
  insert = {
    a = { fg = '#0087dd', bg = '#ffffff', gui = 'bold' },
    b = { fg = '#ffffff', bg = '#0087dd', },
  },
  visual = {
    a = { fg = '#ff4b00', bg = '#ffffff', gui = 'bold' },
    b = { fg = '#ffffff', bg = '#ff4b00' },
  },
  replace = {
    a = { fg = '#ff027f', bg = '#ffffff', gui = 'bold' },
    b = { fg = '#ffffff', bg = '#ff027f' },
  },
  inactive = {
    a = { fg = '#5f5f5f', bg = '#262622' },
    b = { fg = '#5f5f5f', bg = '#262622' },
    c = { fg = '#5f5f5f', bg = '#262622' },
  },
}

Evokai.terminal = Evokai.insert

local separators_config = {
  left = '',
  right = '',
}

local mode_config = {
  'mode',
  padding = 0,
  -- Print 3 letter shorthands for all modes
  fmt = function(name)
    local firstChar = string.sub(name, 1, 1)
    return " "..firstChar.." "
    -- local secondChar = string.sub(name, 2, 2)
    -- -- If the first character is not "V", return it with spaces around
    -- if firstChar ~= "V" or secondChar ~= '-' then
    --   return " " .. string.sub(name, 1, 3) .. " "
    -- end
    --
    -- local afterDash = string.sub(name, 3, 3)
    -- return " V:" .. afterDash .. " "
  end
}

function convertPath(input)
  local _, actualPath = input:match("^vaffle://(%d+)//(.*)")
  if actualPath then
    return "/" .. actualPath
  else
    return "Vaffle "
  end
end

local filename_component = {
  'filename',
  path = 1,
  symbols = {
    modified = '+',
    readonly = '×',
    unnamed = '',
    newfile = 'New'
  },
  padding = {
    left = 1,
    right = 1,
  },
  fmt = function(str, ctx)
    if string.match(str, "^fugitive:") then
      return 'Fugitive '
    end

    if string.match(str, "^vaffle:") then
      return convertPath(str)
    end
    -- vim.api.nvim_notify('notcaught', 1, {})
    -- vim.api.nvim_echo({{vim.inspect(ctx), "Normal"}}, true, {})
    return str
  end,
}


local branch_component = {
  'branch',
  separator = '',
  padding = {
    left = 1,
    right = 0
  }
}

local filetype_component = {
  'filetype',
  colored = false,
  padding = {
    left = 1,
    right = 1,
  },
}

local diagnostics_component = {
  'diagnostics',
  sections = { 'error', 'warn' },
  colored = true,
  diagnostics_color = {
    error = {fg = "#ffffff", bg = '#e60000'},
    warn = {fg = "#000000", bg = '#fff600'},
  },
}

local diff_component = { 'dif' }

local selection_component = {
  'selectioncount',
  padding = {
    left = 1,
    right = 0,
  },
  separator = '',
  fmt = function(str)
    if str == nill or str == "" then
      return ''
    end
    return "["..str.."]"
  end
}

require('lualine').setup({
  options = {
    theme = Evokai,
    icons_enabled = false,
    section_separators = separators_config,
    component_separators = separators_config,
    always_show_tabline = false,
  },
  sections = {
    lualine_a = {
      mode_config
    },
    lualine_b = {
      selection_component,
      filename_component,
      diff_component,
    },
    lualine_c = {
      branch_component
    },
    lualine_x = {
      filetype_component
    },
    lualine_y = {
      {
        'lsp_status',
        icon = '', -- f013
        symbols = {
          -- Standard unicode symbols to cycle through for LSP progress:
          spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          -- Standard unicode symbol for when LSP is done:
          done = '✓',
          -- Delimiter inserted between LSP names:
          separator = ' ',
        },
        ignore_lsp = {},
      }
    },
    lualine_z = {
      diagnostics_component
    }
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
      diagnostics_component
    }
  },
  tabline = {
    lualine_a = {},
    lualine_b = {
      {
        'tabs',
        path = 0,
        mode = 1,
        tabs_color = {
          -- Same values as the general color option can be used here.
          active = 'lualine_b_normal',     -- Color for active tab.
          inactive = 'lualine_c_inactive', -- Color for inactive tab.
        },
        symbols = {
          modified = '+',  -- Text to show when the file is modified.
        },
      },
    },
  },
  -- winbar = {
  --   lualine_c = { 'filename' },
  -- }
})

require("conform").setup({
  -- Define formatters by filetype
  formatters_by_ft = {
    javascript = { "prettier", "biome" },
    typescript = { "prettier", "biome" },
    javascriptreact = { "prettier", "biome" },
    typescriptreact = { "prettier", "biome" },
    json = { "prettier", "biome" },
    html = { "prettier" },
    css = { "prettier" },
    markdown = { "prettier" },
    lua = { "stylua" },
  },
  -- Format on save
  -- format_on_save = {
  --   lsp_fallback = true,
  --   timeout_ms = 500,
  -- },
})

-- .lvimrc snippet to fix on save
-- if has('nvim')
-- lua <<EOF
-- require("conform").setup({
--   format_on_save = {
--     lsp_fallback = true,
--     timeout_ms = 2000,
--   },
-- })
-- EOF
-- endif

-- Diagnostics config
-- I should look at configuring this with eslint and all that, so I won't need to use Ale
vim.diagnostic.config({
  virtual_text = {
    prefix = "",  -- Remove default prefix (usually severity indicator)
    suffix = "",  -- Remove default suffix
    spacing = 0,
    source = false,
    current_line = true,
    virt_text_pos = "eol",
    hl_mode = "replace",
    severity = {
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.ERROR
    },
    -- In case I want to format the text in a future life
    -- format = function(diagnostic)
    --   return diagnostic.message
    -- end,
  },
  -- virtual_lines = {
  --   current_line = true,
  -- },
  -- float = false,
  float = false,
  -- float = {
  --   scope = "cursor",
  --   severity = {
  --     vim.diagnostic.severity.WARN,
  --     vim.diagnostic.severity.ERROR
  --   },
  -- },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '×',
      [vim.diagnostic.severity.WARN] = '·',
    }
  },
  underline = false,
  -- underline = {
  --   severity = {
  --     vim.diagnostic.severity.WARN,
  --     vim.diagnostic.severity.ERROR
  --   },
  -- },
  update_in_insert = false,
  severity_sort = true,
})

-- Leader Key Config
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("v", "q", "<nop>")
vim.g.mapleader = "q"
vim.g.maplocalleader = "q"
vim.keymap.set("n", "Q", "q")
vim.keymap.set("v", "Q", "q")

-- Trying out some improved Term buffer interactions
-- Match Vim's hotkeys for popping into normal mode and using <c-w>
vim.api.nvim_set_keymap('t', '<C-w>N', '<C-\\><C-n>', {noremap = true})
vim.api.nvim_set_keymap('t', '<C-w>.', '<C-w>', {noremap = true})

-- By default neovim's terminal isn't in insert mode, I always want to be in
-- insert mode when I spawn a buffer
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("startinsert")
  end
})

-- Formatting (equivalent to ALEFix)
vim.keymap.set("n", "<leader>ff", function()
  require("conform").format({
    lsp_fallback = true,
    timeout_ms = 2000,
  })
end, { desc = "Format document" })
vim.keymap.set('n', '<leader>fw', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Trim whitespace' })

vim.keymap.set('n', '<leader>aa', vim.lsp.buf.hover, { desc = 'Show hover documentation' })
vim.keymap.set('n', '<leader>ad', vim.diagnostic.open_float, { desc = 'Show diagnostic details' })
vim.keymap.set('n', '<leader>fe', function()
  vim.lsp.buf.format({ async = true, name = "eslint" })
end, { desc = 'Fix with ESLint' })

vim.keymap.set('n', '<leader>jd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })

if vim.g.neovide then
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_floating_shadow = false;
  -- vim.opt.linespace = 3
  -- vim.o.guifont="Berkeley Mono:h16"
  local default_path = vim.fn.expand("~")
  vim.api.nvim_set_current_dir(default_path)
  -- Doesn't seem to work...
  -- local alpha = function()
  --   return string.format("%x", 255)
  -- end
  -- vim.g.neovide_background_color = '#1b1b13' .. alpha()
  vim.keymap.set('n', '∆', function() vim.diagnostic.goto_next({float = false}) end, { desc = 'Go to next diagnostic' })
  vim.keymap.set('n', '˚', function() vim.diagnostic.goto_prev({float = false}) end, { desc = 'Go to previous diagnostic' })
else
  -- Navigate through the diagnostics in the file
  vim.keymap.set('n', '<A-j>', function() vim.diagnostic.goto_next({float = false}) end, { desc = 'Go to next diagnostic' })
  vim.keymap.set('n', '<A-k>', function() vim.diagnostic.goto_prev({float = false}) end, { desc = 'Go to previous diagnostic' })
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

-- Fix various help files being detected properly
vim.cmd([[ autocmd BufRead,BufNewFile */doc/* set filetype=help ]])

-- Think about this boi-oh a bit more...
vim.o.winborder = 'rounded'

-- Setup Hop.nvim
require'hop'.setup { case_insensitive = true }

-- General settings
vim.opt.encoding = "utf-8"
vim.cmd("scriptencoding utf-8")
vim.opt.linebreak = true
vim.opt.ttyfast = true
vim.opt.confirm = true
vim.opt.hidden = true
vim.opt.autoread = true
vim.opt.modeline = false

-- Indent settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.wrap = false
vim.opt.display = "lastline"
vim.opt.lazyredraw = true
vim.opt.updatetime = 100
vim.opt.ttimeoutlen = 0
vim.opt.belloff = "esc"
vim.opt.clipboard = "unnamed"
vim.opt.backupcopy = "yes"
vim.opt.showcmd = false
vim.opt.mousescroll = "ver:1,hor:1"

-- Show invisibles
vim.opt.list = true
vim.opt.listchars = {
  tab = "›\\ ",
  trail = "⋅",
  nbsp = "␣",
}
vim.opt.showbreak = "…"
vim.opt.showmode = false
vim.opt.isfname:append({ "[", "]", "(", ")" })

-- Have the showbreak appear in the number column
vim.opt.cpoptions:append("n")

-- Terminal list tweaks
vim.api.nvim_create_augroup("terminal_list_tweaks", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal_list_tweaks",
  callback = function()
    vim.opt_local.list = false
  end,
})

-- Allow backspacing over everything in insert mode
vim.opt.backspace = "indent,eol,start"

-- Lots of history
vim.opt.history = 1000

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tab completion when entering filenames
vim.opt.wildmenu = true
vim.opt.wildoptions = "pum"
vim.opt.wildmode = "longest:full"
vim.opt.wildignore = {
  "*.o", "*.obj", ".git", "*.rbc", ".hg", ".svn", "*.pyc", ".vagrant", ".DS_Store",
  "*.jpg", "*.eps", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.psd", "*.sublime-project"
}

-- Syntax and colorscheme
vim.opt.background = "dark"
vim.cmd("syntax on")
vim.cmd("syntax sync fromstart")
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Fold Settings
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.sessionoptions = "buffers,tabpages,curdir,slash"
vim.opt.viewoptions = "slash,cursor"

-- Format Options
vim.opt.formatoptions:append("njt")
vim.opt.formatoptions:remove("o")
vim.opt.formatoptions:remove("r")

-- Break indent options
vim.opt.breakindent = true
vim.opt.breakindentopt = "sbr"

-- Colors
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
  vim.cmd("colorscheme evokai")
else
  vim.cmd("colorscheme molokai")
end

-- Cursor settings
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkwait300-blinkoff150-blinkon150,ve:ver35-Cursor,o:hor15-Cursor,i-ci-c:ver25-Cursor/lCursor-blinkwait300-blinkoff150-blinkon150,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait300-blinkoff150-blinkon150"
vim.opt.shortmess = "ITFaocC"

-- Title string
vim.opt.titlestring = "%{substitute(getcwd(), $HOME, '~', '')}"
vim.opt.ruler = false
vim.opt.fillchars = {
  vert = "⋅",
  fold = "-",
}

-- Visual mode paste improvements
vim.keymap.set("v", "p", "pgvy")

-- Number column
vim.opt.number = true
vim.opt.numberwidth = 3

vim.api.nvim_create_augroup("hidenumber", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "hidenumber",
  pattern = "vaffle",
  callback = function()
    vim.opt_local.number = false
  end,
})

-- Sign column
vim.opt.signcolumn = "yes"

vim.api.nvim_create_augroup("hidesigns", { clear = true })
vim.api.nvim_create_autocmd("BufNew", {
  group = "hidesigns",
  callback = function()
    vim.opt_local.signcolumn = "yes"
  end,
})
vim.api.nvim_create_autocmd("BufNew", {
  group = "hidesigns",
  pattern = "__Scratch__",
  callback = function()
    vim.opt_local.signcolumn = "no"
  end,
})
vim.api.nvim_create_autocmd("BufNew", {
  group = "hidesigns",
  pattern = ".scratch.md",
  callback = function()
    vim.opt_local.signcolumn = "no"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "hidesigns",
  pattern = { "vim-plug", "vaffle", "qf", "help", "startify", "nerdtree", "git", "gitcommit" },
  callback = function()
    vim.opt_local.signcolumn = "no"
  end,
})

-- Status line
vim.opt.laststatus = 2

vim.api.nvim_create_augroup("laststatus", { clear = true })
vim.api.nvim_create_autocmd("BufNew", {
  group = "laststatus",
  callback = function()
    vim.opt_local.laststatus = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "laststatus",
  pattern = "startify",
  callback = function()
    vim.opt_local.laststatus = 0
  end,
})

-- Sentence settings
vim.opt.cpoptions:append("J")

-- Font settings
if vim.fn.has("gui_running") == 1 then
  vim.opt.guifont = "BerkeleyMono-Regular:h16"
  vim.opt.macligatures = true
else
  vim.opt.guifont = "Berkeley Mono:h16"
end

-- Split settings
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Scroll settings
vim.opt.scrolloff = 3
vim.opt.sidescroll = 0
vim.opt.sidescrolloff = 5

-- Completion settings
vim.opt.complete = ".,w,b,u,t"
vim.opt.completeopt = "menuone,menu,noselect"

-- Diff settings
vim.opt.diffopt:append({ "algorithm:patience", "vertical", "indent-heuristic" })

-- Key Mappings
vim.keymap.set({ "n", "i" }, "<F1>", "<Esc>")
vim.keymap.set("i", "<C-x><C-x>", "<C-x><C-o>")
vim.keymap.set("n", "K", "<Nop>")
vim.keymap.set("n", "Y", "yy")

-- Command abbreviations
vim.cmd([[
  cnoreabbrev W w
  cnoreabbrev Wq wq
  cnoreabbrev WQ wq
  cnoreabbrev Q q
  cnoreabbrev Qa qa
  cnoreabbrev QA qa
  cnoreabbrev db bd
  cnoreabbrev Tabe tabe
  cnoreabbrev Edit edit
  cnoreabbrev Vsplit vsplit
  cnoreabbrev Set set
  cnoreabbrev Cd cd
  cnoreabbrev CD cd
  cnoreabbrev Src source $MYVIMRC
]])

-- Custom commands
vim.api.nvim_create_user_command("Fu", function()
  vim.opt.fullscreen = not vim.opt.fullscreen:get()
  vim.cmd("redraw!")
end, {})

-- Easier buffer closing
vim.keymap.set("n", "<C-w>q", ":bd<CR>")

-- Line wrap movement
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

-- Leader mappings
vim.keymap.set("n", "<F5>", ":syntax sync fromstart<CR>")
vim.keymap.set("n", "<leader>nn", ":set hls!<CR>")
vim.keymap.set("n", "<leader>e", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>mc", ":e ~/.config/nvim/colors/evokai.lua<CR>")
vim.keymap.set("n", "<leader>hh", ":runtime! /syntax/hitest.vim<CR>")
vim.keymap.set("n", "<leader>u", ":MundoToggle<CR>")
vim.keymap.set("n", "<leader>dd", "<C-w>h:bd<CR>")
vim.keymap.set("n", "<leader>ss", ":setlocal spell!<CR>")
vim.keymap.set("n", "<leader>gg", ":Gvdiff<CR>")
vim.keymap.set("n", "<leader>pp", ":pwd<CR>")
vim.keymap.set("n", "<leader>gs", ":Gstatus<CR>")
vim.keymap.set("n", "<leader>gc", ":Gcommit -v<CR>")
vim.keymap.set("n", "<leader>gd", ":silent Git difftool --staged<CR>")
vim.keymap.set("n", "<leader>sr", ":syntax sync fromstart<CR>")
vim.keymap.set("n", "<leader>sf", ":set filetype=javascript.jsx<CR>")
vim.keymap.set("n", "<leader>rd", ":redraw!<CR>")
vim.keymap.set("n", "<leader>ww", ":w<CR>")
vim.keymap.set("n", "<leader>wf", ":Fu<CR>")
vim.keymap.set("n", "<D-CR>", ":set fu!<CR>")

-- Window movement
vim.keymap.set({ "n", "v" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-w>l")
vim.keymap.set("n", "gF", "<C-w>vg_hhgf")

-- Insert mode escaping
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "JK", "<Esc>")

-- Insert mode cursor movement
vim.keymap.set("i", "<C-k>", "<Esc>O")
vim.keymap.set("i", "<C-l>", "<Esc>A")
vim.keymap.set("i", "<C-h>", "<Esc>I")
vim.keymap.set("i", "<C-j>", "<Esc>o")
vim.keymap.set("i", "<C-d>", "<Esc>v^c")
vim.keymap.set("i", "<C-e>", "<C-x><C-e>")
vim.keymap.set("i", "<C-y>", "<C-x><C-y>")

-- Fix accidental insert mode commands
vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>")
vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>")

-- Command mode improvements
if vim.fn.has("gui_running") == 1 then
  vim.keymap.set("c", "<C-k>", "<Up>")
  vim.keymap.set("c", "<C-j>", "<Down>")
end

-- Expand folder of current file in command mode
vim.keymap.set("c", "%%", function()
  return vim.fn.expand("%:h") .. "/"
end, { expr = true })

-- Disable middle mouse behavior
vim.keymap.set({ "n", "i", "v" }, "<MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<2-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<3-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<4-MiddleMouse>", "<Nop>")

-- Sidescrolling shortcuts
if vim.fn.has("mac") == 1 then
  -- <opt-h>
  vim.keymap.set("n", "˙", "zh", { silent = true })
  -- <opt-l>
  vim.keymap.set("n", "¬", "zl", { silent = true })
else
  -- <alt-h>
  vim.keymap.set("n", "<A-h>", "zh", { silent = true })
  -- <alt-l>
  vim.keymap.set("n", "<A-l>", "zl", { silent = true })
end

-- Vaffle configurations
vim.keymap.set("n", "<leader>vv", ":Vaffle<CR>")
vim.keymap.set("n", "<leader>vf", ":Vaffle %<CR>")

vim.api.nvim_create_augroup("vaffletab", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "vaffletab",
  pattern = "vaffle",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "<Plug>(vaffle-toggle-current)", {})
    vim.api.nvim_buf_set_keymap(0, "n", "s", "<Plug>(vaffle-open-selected-vsplit)", {})
  end,
})

-- Swap, Undo and Backup Folder Configuration
vim.opt.directory = vim.fn.expand("~/.config/nvim/swap")
vim.opt.backupdir = vim.fn.expand("~/.config/nvim/backup")
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- Search for selected text
local function get_selection()
  local old_reg = vim.fn.getreg("v")
  vim.cmd('normal! gv"vy')
  local raw_search = vim.fn.getreg("v")
  vim.fn.setreg("v", old_reg)
  return vim.fn.substitute(vim.fn.escape(raw_search, [[\/.&*$^~[]]), "\n", "\\n", "g")
end

vim.keymap.set("v", "<C-s>", function()
  return "/<C-r>=" .. get_selection() .. "<CR><CR>"
end, { expr = true })

vim.keymap.set("v", "#", function()
  return "?<C-r>=" .. get_selection() .. "<CR><CR>"
end, { expr = true })

-- .conf to yaml
vim.api.nvim_create_augroup("yaml", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = "yaml",
  pattern = "*.conf",
  callback = function()
    vim.opt_local.filetype = "yaml"
  end,
})

-- CSS Specific Motions
vim.keymap.set("o", "ik", ":<C-u>execute \"normal! ^vt:\"<CR>")
vim.keymap.set("o", "ak", ":<C-u>execute \"normal! 0vf:\"<CR>")

-- Fun abbreviations
vim.cmd([[
  iabbrev ldis ಠ_ಠ
  iabbrev lsad ಥ_ಥ
  iabbrev lhap ಥ‿ಥ
  iabbrev lmis ಠ‿ಠ
  iabbrev ldiz ( ͠° ͟ʖ ͡°)
]])

vim.keymap.set("v", "u", "<Nop>")
vim.keymap.set("v", "gu", "u")
vim.keymap.set("n", "<leader>se", ":source Session.vim<CR>")

-- Easy profiling
local function profile_start()
  vim.cmd([[
    profile start profile.log
    profile func *
    profile file *
  ]])
end

local function profile_end()
  vim.cmd([[
    profile pause
    noautocmd qall!
  ]])
end

vim.api.nvim_create_user_command("ProfileStart", profile_start, {})
vim.api.nvim_create_user_command("ProfileEnd", profile_end, {})
vim.api.nvim_create_user_command("MiniTerm", "term ++rows=10", {})

local function wipeout_buffers()
  vim.cmd("%bwipeout")
end

vim.api.nvim_create_user_command("Wipeout", wipeout_buffers, {})

-- ==== PLUGIN SETTINGS ===

-- Gist settings
vim.g.gist_clip_command = "pbcopy"
vim.g.gist_open_browser_after_post = 1

-- DetectIndent Settings
vim.g.detectindent_max_lines_to_analyse = 1024

vim.api.nvim_create_augroup("detectindent", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "detectindent",
  callback = function()
    vim.cmd("DetectIndent")
  end,
})

-- Fugitive Settings
vim.api.nvim_create_augroup("fugitivefix", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "fugitivefix",
  pattern = "fugitive:///*",
  callback = function()
    vim.opt_local.bufhidden = "delete"
  end,
})

vim.api.nvim_create_augroup("gitcommit", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "gitcommit",
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.list = false
  end,
})

-- vim-escaper Custom Entity Replacements
vim.g.CustomEntities = {{"(c)", "\\&copy;"}}

-- Grepper
vim.g.grepper = {
  highlight = 1,
  searchreg = 1,
  tools = { "rg", "ag", "ack", "ack-grep", "grep", "findstr", "pt", "sift", "git" }
}

vim.keymap.set("n", "gs", "<Plug>(GrepperOperator)")
vim.keymap.set("x", "gs", "<Plug>(GrepperOperator)")

-- Goyo settings
vim.g.goyo_margin_top = 5
vim.g.goyo_margin_bottom = 5
vim.g.goyo_width = 90

-- Hop.nvim Mappings
vim.keymap.set({"n", "v", "o"}, "<leader>/", "<cmd>HopPattern<CR>")
vim.keymap.set({"n", "v"}, "<leader>kk", "<cmd>HopLine<CR>")
vim.keymap.set({"n", "v"}, "<leader>jj", "<cmd>HopLine<CR>")
vim.keymap.set({"n", "v"}, "<space>", "<cmd>HopChar1<CR>")

-- LocalVimRC Settings
vim.g.localvimrc_sandbox = 0
vim.g.localvimrc_persistent = 1

-- targets.vim
vim.api.nvim_create_augroup("targets_tweaks", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "targets_tweaks",
  pattern = "targets#mappings#user",
  callback = function()
    vim.fn["targets#mappings#extend"]({
      a = { argument = {{ o = "[{([]", c = "[])}]", s = "," }} }
    })
  end,
})

-- Scratch settings
vim.g.scratch_autohide = 0
vim.g.scratch_insert_autohide = 0
vim.g.scratch_filetype = "markdown"
vim.g.scratch_top = 0

-- vim-hexokinase
vim.g.Hexokinase_highlighters = { "virtual" }
vim.g.Hexokinase_ftEnabled = {
  "css", "html", "javascript", "typescript", "typescriptreact", "typescript.tsx", "javascript.jsx"
}

-- EditorConfig
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
vim.g.EditorConfig_disable_rules = { "trim_trailing_whitespace" }

-- VIM Open Url
vim.g.open_url_default_mappings = 0
vim.keymap.set({"n"}, "gx", "<Plug>(open-url-browser)")
vim.keymap.set({"x"}, "gx", "<Plug>(open-url-browser)")

-- Vim Matchup Settings
vim.g.loaded_matchit = 1 -- Disable matchit because we are using matchup
vim.g.matchup_transmute_enabled = 1
vim.g.matchup_matchparen_offscreen = {method = "popup"}
vim.g.matchup_surround_enabled = 1
vim.g.matchup_matchparen_deferred = 1

-- Vim Plug Settings
vim.g.plug_threads = 200

-- Zig Settings
vim.g.zig_fmt_autosave = 0

-- direnv config
vim.g.direnv_silent_load = 1

-- Create required directories
local function ensure_directory(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_directory(vim.fn.expand("~/.config/nvim/swap"))
ensure_directory(vim.fn.expand("~/.config/nvim/backup"))
ensure_directory(vim.fn.expand("~/.config/nvim/undo"))
