-- Use Neovim's built-in ui2 layer for messages and the cmdline.
-- This removes most hit-enter prompts without replacing completion UI.
vim.o.cmdheight = 1

local ok, ui2 = pcall(require, "vim._core.ui2")
if ok and type(ui2.enable) == "function" then
  vim.opt.messagesopt:append({ "maxheight:50", "timeout:5000" })

  local opts = {
    enable = true,
    msg = {
      targets = "cmd",
      -- Worth playing around more with these...
      -- targets = {
      --   [""] = "cmd",
      --   -- empty = "pager",
      --   bufwrite = "cmd",
      --   confirm = "cmd",
      --   emsg = "cmd",
      --   echo = "cmd",
      --   echomsg = "cmd",
      --   echoerr = "cmd",
      --   completion = "cmd",
      --   list_cmd = "cmd",
      --   lua_error = "cmd",
      --   lua_print = "cmd",
      --   progress = "cmd",
      --   rpc_error = "cmd",
      --   -- quickfix = "msg",
      --   search_cmd = "cmd",
      --   search_count = "cmd",
      --   shell_cmd = "cmd",
      --   shell_err = "cmd",
      --   shell_out = "cmd",
      --   shell_ret = "cmd",
      --   undo = "cmd",
      --   verbose = "cmd",
      --   wildlist = "cmd",
      --   wmsg = "cmd",
      --   typed_cmd = "cmd",
      -- },
      dialog = {
        height = 0.5,
      },
      msg = {
        height = 0.3,
      },
      pager = {
        height = 0.5,
      },
    },
  }

  local enabled, err = pcall(ui2.enable, opts)
  if not enabled then
    vim.schedule(function()
      vim.notify("Failed to enable UI2: " .. tostring(err), vim.log.levels.ERROR)
    end)
  end
end

return {}
