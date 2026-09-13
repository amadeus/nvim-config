local profiling = false

local function profile_start()
  if profiling then
    vim.notify("Profiling is already running", vim.log.levels.WARN)
    return
  end

  local profiler = require("jit.p")
  -- Sample Lua stacks and VM states every 1 ms, retaining all sampled entries.
  profiler.start("vl10pri1m0", "profile-lua.log")
  vim.cmd([[
    profile start profile.log
    profile func *
    profile file *
  ]])
  profiling = true
end

local function profile_end()
  if not profiling then
    vim.notify("Profiling is not running", vim.log.levels.WARN)
    return
  end

  require("jit.p").stop()
  profiling = false
  vim.cmd([[
    profile stop
  ]])
end

vim.api.nvim_create_user_command("ProfileStart", profile_start, {})
vim.api.nvim_create_user_command("ProfileEnd", profile_end, {})

return {}
