-- Neovide specific settings

if vim.g.neovide then
  -- Key mappings
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode

  -- Neovide UI settings
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.01
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_cursor_smooth_blink = false
  -- Maybe not a safe setting to use?
  -- vim.api.nvim_set_current_dir(vim.fn.expand("~"))

  -- Diagnostics navigation keymaps
  -- Unset the default diagnostic hotkeys because neovide is special
  vim.keymap.del("n", "<A-j>", {})
  vim.keymap.del("n", "<A-k>", {})
end

return {}
