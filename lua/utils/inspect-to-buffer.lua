local M = {}

function M.inspect_to_buffer(value, buffer_name)
  buffer_name = buffer_name or "Inspection"
  vim.cmd("botright new " .. buffer_name)
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  local lines = vim.split(vim.inspect(value), "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
  return buf
end

return M
