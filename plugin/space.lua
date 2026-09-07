-- :Space rename <name> gives the current tab a custom label in the tabline.
-- Names follow their tabs when reordered and are saved in Obsession sessions.
vim.api.nvim_create_user_command("Space", function(opts)
  local name = vim.trim(opts.args):match("^rename%s+(.+)$")
  if not name then
    vim.notify("Usage: :Space rename <name>", vim.log.levels.ERROR)
    return
  end

  vim.t.tabname = name
  require("lualine").refresh({ place = { "tabline" } })
end, {
  nargs = "+",
  desc = "Rename the current tab",
  complete = function(arglead, cmdline, cursorpos)
    if cmdline:sub(1, cursorpos):match("^%s*Space%s+%S*$") and vim.startswith("rename", arglead) then
      return { "rename" }
    end
    return {}
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("SpaceSession", { clear = true }),
  pattern = "ObsessionPre",
  callback = function()
    local lines = {}
    for tabnr, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
      local name = vim.t[tabpage].tabname or ""
      lines[#lines + 1] = string.format("call settabvar(%d, 'tabname', %s)", tabnr, vim.fn.string(name))
    end
    vim.g.obsession_append = lines
  end,
})
