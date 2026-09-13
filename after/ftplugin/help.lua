if vim.bo.buftype == "help" then
  vim.opt_local.signcolumn = "no"
end

local opts = { buf = 0, noremap = true }

vim.keymap.set("n", "<CR>", "<C-]>", opts)
vim.keymap.set("n", "<BS>", "<C-T>", opts)
vim.keymap.set("n", "o", [[/'\l\{2,\}'<CR>]], opts)
vim.keymap.set("n", "O", [[?'\l\{2,\}'<CR>]], opts)
vim.keymap.set("n", "s", [[/\|\zs\S\+\ze\|<CR>]], opts)
vim.keymap.set("n", "S", [[?\|\zs\S\+\ze\|<CR>]], opts)
