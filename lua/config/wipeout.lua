local function wipeout_buffers()
  vim.cmd("%bwipeout")
end

vim.api.nvim_create_user_command("Wipeout", wipeout_buffers, {})

return {}
