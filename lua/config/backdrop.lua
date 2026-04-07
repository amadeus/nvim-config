-- Unify the backdrop floats used by modal-style plugin windows so they fade
-- toward the current colorscheme background instead of dimming toward black.
-- This currently targets the fullscreen overlays used by lazy.nvim,
-- mason.nvim, and snacks.nvim.
local backdrop = require("utils.backdrop")

local backdrop_group = vim.api.nvim_create_augroup("backdrop_fade", { clear = true })

-- Define the shared highlight immediately so the current colorscheme gets the
-- custom backdrop even before the next ColorScheme event fires.
backdrop.apply_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = backdrop_group,
  desc = "User: keep modal backdrops aligned with Normal bg",
  -- Recompute the backdrop color whenever the theme changes so it continues
  -- to track the active Normal background.
  callback = backdrop.apply_highlight,
})

vim.api.nvim_create_autocmd("FileType", {
  group = backdrop_group,
  desc = "User: fade modal backdrops toward the theme bg",
  pattern = { "lazy_backdrop", "mason_backdrop", "snacks_win_backdrop" },
  callback = function(ctx)
    -- These plugins expose their backdrops as special buffers. The helper
    -- finds the backing window and reapplies the shared highlight, including a
    -- deferred pass for plugins like snacks.nvim that create the window a bit
    -- later in their open sequence.
    backdrop.style_buffer(ctx.buf)
  end,
})

return {}
