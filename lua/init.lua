-- Create required directories
local function ensure_directory(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_directory(vim.fn.expand("~/.config/nvim/swap"))
ensure_directory(vim.fn.expand("~/.config/nvim/backup"))
ensure_directory(vim.fn.expand("~/.config/nvim/undo"))

-- Swap, Undo and Backup Folder Configuration
vim.opt.directory = vim.fn.expand("~/.config/nvim/swap")
vim.opt.backupdir = vim.fn.expand("~/.config/nvim/backup")
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- Diagnostics config
-- I should look at configuring this with eslint and all that, so I won't need to use Ale
vim.diagnostic.config({
  virtual_text = {
    prefix = "", -- Remove default prefix (usually severity indicator)
    suffix = "", -- Remove default suffix
    spacing = 0,
    source = false,
    current_line = true,
    virt_text_pos = "eol",
    hl_mode = "replace",
    severity = {
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.ERROR,
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
      [vim.diagnostic.severity.ERROR] = "×",
      [vim.diagnostic.severity.WARN] = "ë",
    },
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

-- Leader Key Config -- Leader is set in .config/nvim/init.lua because that's
-- where it needs to live

-- Trying out some improved Term buffer interactions
-- Match Vim's hotkeys for popping into normal mode and using <c-w>
vim.api.nvim_set_keymap("t", "<C-w>N", "<C-\\><C-n>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-w>.", "<C-w>", { noremap = true })

-- Figure out how to actually get this...
-- vim.keymap.set('n', '<leader>fw', function()
--   vim.lsp.buf.format({ async = true })
-- end, { desc = 'Trim whitespace' })

vim.keymap.set("n", "<leader>aa", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "<leader>ad", vim.diagnostic.open_float, { desc = "Show diagnostic details" })
vim.keymap.set("n", "<leader>fe", function()
  vim.lsp.buf.format({ async = true, name = "eslint" })
end, { desc = "Fix with ESLint" })

vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>fr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set("n", "<F7>", ":Inspect<CR>", { desc = "Show Syntax Stack" })
vim.keymap.set("i", "<F7>", ":Inspect<CR>", { desc = "Show Syntax Stack" })

if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_floating_shadow = false
  -- vim.opt.linespace = 3
  -- vim.o.guifont="Berkeley Mono:h16"
  local default_path = vim.fn.expand("~")
  vim.api.nvim_set_current_dir(default_path)
  -- Doesn't seem to work...
  -- local alpha = function()
  --   return string.format("%x", 255)
  -- end
  -- vim.g.neovide_background_color = '#1b1b13' .. alpha()
  vim.keymap.set("n", "∆", function()
    vim.diagnostic.jump({ count = 1, float = false })
  end, { desc = "Go to next diagnostic" })
  vim.keymap.set("n", "˚", function()
    vim.diagnostic.jump({ count = -1, float = false })
  end, { desc = "Go to previous diagnostic" })
else
  -- Navigate through the diagnostics in the file
  vim.keymap.set("n", "<A-j>", function()
    vim.diagnostic.jump({ count = 1, float = false })
  end, { desc = "Go to next diagnostic" })
  vim.keymap.set("n", "<A-k>", function()
    vim.diagnostic.jump({ count = -1, float = false })
  end, { desc = "Go to previous diagnostic" })
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- Fix various help files being detected properly
vim.cmd([[ autocmd BufRead,BufNewFile */doc/* set filetype=help ]])

-- Think about this boi-oh a bit more...
vim.o.winborder = "rounded"

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
    vim.cmd("startinsert")
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
  "*.o",
  "*.obj",
  ".git",
  "*.rbc",
  ".hg",
  ".svn",
  "*.pyc",
  ".vagrant",
  ".DS_Store",
  "*.jpg",
  "*.eps",
  "*.jpeg",
  "*.png",
  "*.gif",
  "*.bmp",
  "*.psd",
  "*.sublime-project",
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
vim.opt.guicursor =
  "n-v-c:block-Cursor/lCursor-blinkwait300-blinkoff150-blinkon150,ve:ver35-Cursor,o:hor15-Cursor,i-ci-c:ver25-Cursor/lCursor-blinkwait300-blinkoff150-blinkon150,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait300-blinkoff150-blinkon150"
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

-- Sentence settings
vim.opt.cpoptions:append("J")

-- Font settings
if
  pcall(function()
    ---@diagnostic disable-next-line: undefined-field
    return vim.opt.guifont:get()
  end)
then
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

-- Easier buffer closing
vim.keymap.set("n", "<C-w>q", ":bd<CR>")

-- Line wrap movement
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

-- Leader mappings
vim.keymap.set("n", "<F5>", ":syntax sync fromstart<CR>")
vim.keymap.set("n", "<leader>nn", ":set hls!<CR>")
-- Figure out how to fix this...
-- vim.keymap.set("n", "<leader>e", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>e", ":e ~/.local/share/nvim/lazy/nvim-config/lua/init.lua<CR>")
vim.keymap.set("n", "<leader>dd", "<C-w>h:bd<CR>")
vim.keymap.set("n", "<leader>ss", ":setlocal spell!<CR>")
vim.keymap.set("n", "<leader>pp", ":pwd<CR>")
vim.keymap.set("n", "<leader>sr", ":syntax sync fromstart<CR>")
vim.keymap.set("n", "<leader>rd", ":redraw!<CR>")
vim.keymap.set("n", "<leader>ww", ":w<CR>")

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

-- Command mode improvements DISABLED BECAUSE I MIGHT NOT NEED IT
-- if vim.fn.has("gui_running") == 1 then
--   vim.keymap.set("c", "<C-k>", "<Up>")
--   vim.keymap.set("c", "<C-j>", "<Down>")
-- end

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
vim.keymap.set("o", "ik", ':<C-u>execute "normal! ^vt:"<CR>')
vim.keymap.set("o", "ak", ':<C-u>execute "normal! 0vf:"<CR>')

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
