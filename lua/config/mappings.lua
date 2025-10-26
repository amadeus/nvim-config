-- General Keymappings
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
vim.keymap.set("n", "<leader>nn", ":set hls!<CR>")
vim.keymap.set("n", "<leader>e", ":e ~/.local/share/nvim/lazy/nvim-config/lua/init.lua<CR>")
vim.keymap.set("n", "<leader>ss", ":setlocal spell!<CR>")
vim.keymap.set("n", "<leader>pp", ":pwd<CR>")
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

-- Expand folder of current file in command mode
vim.keymap.set("c", "%%", function()
  return vim.fn.expand("%:h") .. "/"
end, { expr = true })

-- Disable middle mouse behavior
vim.opt.mousemodel = "extend"
vim.keymap.set({ "n", "i", "v" }, "<MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<2-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<3-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<4-MiddleMouse>", "<Nop>")

-- Sidescrolling shortcuts
-- <alt-h>
vim.keymap.set("n", "<A-h>", "zh", { silent = true })
-- <alt-l>
vim.keymap.set("n", "<A-l>", "zl", { silent = true })

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

vim.keymap.set("n", "<F7>", ":Inspect<CR>", { desc = "Show Syntax Stack" })
vim.keymap.set("i", "<F7>", ":Inspect<CR>", { desc = "Show Syntax Stack" })

-- Paste Settings
vim.api.nvim_set_keymap("t", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
-- Visual mode paste improvements
vim.keymap.set("v", "p", "pgvy")

return {}
