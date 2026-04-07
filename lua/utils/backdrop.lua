local M = {}

-- Neovim returns highlight colors as integers. Convert them back into a hex
-- string so they can be reused in custom highlight definitions.
local function to_hex(color)
  if not color then
    return nil
  end

  return string.format("#%06x", color)
end

function M.normal_bg()
  -- Read the concrete Normal background instead of following links so the
  -- backdrop always matches the active colorscheme's resolved base color.
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  return to_hex(normal.bg)
end

function M.apply_highlight()
  local bg = M.normal_bg()
  if not bg then
    return
  end

  -- Backdrop windows keep their original winblend values. By swapping their
  -- base color from black to Normal.bg, the overlay fades toward the theme
  -- background instead of darkening toward black.
  vim.api.nvim_set_hl(0, "BackdropFade", { bg = bg })
end

function M.style_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end

  -- Some plugins create a borderless fullscreen float behind the real modal.
  -- Repoint that float's Normal highlight to the shared backdrop color.
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
  -- snacks.nvim assigns the backdrop buffer filetype before the backdrop
  -- window exists, so do a second pass on the next loop tick to catch it.
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(buf) then
      style_buffer_windows(buf)
    end
  end)
end

return M
