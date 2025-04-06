-- Neovide specific settings
if vim.g.neovide then
  return {}
end

-- Key mappings
vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
vim.keymap.set("v", "<D-c>", '"+y') -- Copy
vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

-- Neovide UI settings
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_trail_size = 0.01
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_floating_shadow = false
vim.g.neovide_cursor_smooth_blink = false
vim.api.nvim_set_current_dir(vim.fn.expand("~"))

-- Diagnostics navigation keymaps
-- Unset the default diagnostic hotkeys because neovide is special
vim.keymap.del("n", "<A-j>", {})
vim.keymap.del("n", "<A-k>", {})
vim.keymap.set("n", "∆", function()
  vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "˚", function()
  vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "Go to previous diagnostic" })

return {}

