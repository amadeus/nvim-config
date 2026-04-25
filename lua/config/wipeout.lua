local function wipeout_all_buffers()
  pcall(function()
    vim.cmd("%bwipeout")
  end)
end

local dashboard_filetypes = {
  startify = true,
  snacks_dashboard = true,
}

local function wipeout_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(all_bufs) do
    -- Dashboard buffers are disposable, so wipe them with everything else.
    if buf ~= current_buf or dashboard_filetypes[vim.bo[current_buf].filetype] then
      -- Check if the buffer is valid before attempting to wipe it
      if vim.api.nvim_buf_is_valid(buf) then
        -- Use pcall to catch any errors that might occur when trying to wipe a buffer
        pcall(function()
          vim.cmd("bwipeout! " .. buf)
        end)
      end
    end
  end
end

vim.api.nvim_create_user_command("Wipeout", wipeout_buffers, {})
vim.api.nvim_create_user_command("WipeoutAll", wipeout_all_buffers, {})

return {}
