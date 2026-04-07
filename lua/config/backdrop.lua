local backdrop = require("utils.backdrop")

local backdrop_group = vim.api.nvim_create_augroup("backdrop_fade", { clear = true })

backdrop.apply_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = backdrop_group,
  desc = "User: keep modal backdrops aligned with Normal bg",
  callback = backdrop.apply_highlight,
})

vim.api.nvim_create_autocmd("FileType", {
  group = backdrop_group,
  desc = "User: fade modal backdrops toward the theme bg",
  pattern = { "lazy_backdrop", "mason_backdrop", "snacks_win_backdrop" },
  callback = function(ctx)
    backdrop.style_buffer(ctx.buf)
  end,
})

return {}
