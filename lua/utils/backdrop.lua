local M = {}

local function to_hex(color)
  if not color then
    return nil
  end

  return string.format("#%06x", color)
end

function M.normal_bg()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  return to_hex(normal.bg)
end

function M.apply_highlight()
  local bg = M.normal_bg()
  if not bg then
    return
  end

  vim.api.nvim_set_hl(0, "BackdropFade", { bg = bg })
end

function M.style_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end

  vim.api.nvim_win_set_config(win, { border = "none" })
  vim.wo[win].winhighlight = "Normal:BackdropFade"
end

local function style_buffer_windows(buf)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    M.style_window(win)
  end
end

function M.style_buffer(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  style_buffer_windows(buf)
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(buf) then
      style_buffer_windows(buf)
    end
  end)
end

return M
