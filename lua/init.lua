-- Create required directories
local function ensure_directory(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- Swap, Undo and Backup Folder Configuration
ensure_directory(vim.fn.expand("~/.config/nvim/swap"))
ensure_directory(vim.fn.expand("~/.config/nvim/backup"))
ensure_directory(vim.fn.expand("~/.config/nvim/undo"))
vim.opt.directory = vim.fn.expand("~/.config/nvim/swap")
vim.opt.backupdir = vim.fn.expand("~/.config/nvim/backup")
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
vim.opt.swapfile = false
vim.opt.undofile = true

-- Fix various help files being detected properly -- This may need more work
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("fix-help-syntax", { clear = true }),
  pattern = "*/doc/*",
  callback = function()
    vim.bo.filetype = "help"
  end,
})

vim.o.winborder = "rounded"

-- General settings
vim.cmd("scriptencoding utf-8")
vim.opt.linebreak = true
vim.opt.confirm = true
vim.opt.modeline = false

-- Indent settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smartindent = true
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
vim.opt.showmode = false

-- Fucking NextJS
vim.opt.isfname:append({ "[", "]", "(", ")" })

-- Have the showbreak appear in the number column
vim.opt.cpoptions:append("n")

-- Lots of history
vim.opt.history = 1000

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Cursorline settings
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Certain filetypes should have a cursorline, most of the time I don't want it
-- though
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("cursorline-hacks", { clear = true }),
  pattern = { "vaffle", "GV", "fugitive", "gitcommit" },
  callback = function()
    vim.opt_local.cursorlineopt = "both"
  end,
})

-- Only show cursorline on the focused window, to help visuaize what buffer is
-- focused.
local cursorline_focus_group = vim.api.nvim_create_augroup("cursorline-focus", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  group = cursorline_focus_group,
  callback = function()
    vim.wo.cursorline = true
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = cursorline_focus_group,
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Session Settings
vim.opt.sessionoptions = "buffers,tabpages,curdir,slash"
vim.opt.viewoptions = "slash,cursor"

-- Format Options
vim.opt.formatoptions:append("njt")
vim.opt.formatoptions:remove("o")
vim.opt.formatoptions:remove("r")

-- Break indent options
vim.opt.breakindent = true
vim.opt.breakindentopt = "sbr"

-- Cursor settings
vim.opt.guicursor =
  "n-v-c:block-Cursor/lCursor-blinkwait300-blinkoff150-blinkon150,ve:ver35-Cursor,o:hor15-Cursor,i-ci-c:ver25-Cursor/lCursor-blinkwait300-blinkoff150-blinkon150,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait300-blinkoff150-blinkon150"
vim.opt.shortmess = "ITFaocC"

-- Title string
vim.opt.titlestring = "%{substitute(getcwd(), $HOME, '~', '')}"

vim.opt.ruler = false
vim.opt.fillchars = {
  fold = "-",
  diff = "╱",
}

vim.opt.number = true
vim.opt.numberwidth = 3

-- Sign Column Settings - always show, but disable for some buffers
vim.opt.signcolumn = "yes"
vim.api.nvim_create_autocmd("BufNew", {
  group = vim.api.nvim_create_augroup("hidesigns-bufnew", { clear = true }),
  pattern = { "__Scratch__", ".scratch.md" },
  callback = function()
    vim.opt_local.signcolumn = "no"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("hidesigns-filetype", { clear = true }),
  pattern = { "vaffle", "qf", "help", "startify", "git", "gitcommit", "gv" },
  callback = function()
    vim.opt_local.signcolumn = "no"
  end,
})

-- Sentence settings -- 2 spaces == sentence
vim.opt.cpoptions:append("J")

-- Font settings - If we can query a guifont, then we should set it
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

-- Diff settings
-- vim.opt.diffopt:append({ "algorithm:patience", "vertical", "indent-heuristic" })
vim.opt.diffopt = { "vertical", "internal", "filler", "closeoff", "algorithm:histogram", "linematch:120" }

require("config.mappings")
require("config.wipeout")
require("config.profiling")
require("config.lsp")
require("config.neovide")
require("config.terminal")
