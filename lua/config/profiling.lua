-- Note sure if this profiling is even applicable in a Neovim world...
local function profile_start()
  vim.cmd([[
    profile start profile.log
    profile func *
    profile file *
  ]])
end

local function profile_end()
  vim.cmd([[
    profile pause
    noautocmd qall!
  ]])
end

vim.api.nvim_create_user_command("ProfileStart", profile_start, {})
vim.api.nvim_create_user_command("ProfileEnd", profile_end, {})

return {}
