-- Use Neovim's built-in ui2 layer for messages and the cmdline.
-- This removes most hit-enter prompts without replacing completion UI.
local ok, ui2 = pcall(require, "vim._core.ui2")
if ok and type(ui2.enable) == "function" then
  pcall(ui2.enable)
end

return {}
