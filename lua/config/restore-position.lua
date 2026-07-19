-- Restore the last known cursor position when opening a file, using the `"`
-- mark persisted via the shada settings in lua/init.lua
local restore_group = vim.api.nvim_create_augroup("restore-position", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = restore_group,
  pattern = "*",
  callback = function(args)
    -- Only normal file buffers should restore -- this excludes terminal,
    -- help, quickfix, prompt and plugin scratch buffers in one go
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    -- Skip protocol buffers (fugitive://, oil://, ...) -- when gitsigns
    -- reloads a fugitive diff buffer after staging, restoring the mark here
    -- jumps its cursor to line 1 and cursorbind drags the other diff
    -- windows (and the actual cursor) along with it
    if vim.api.nvim_buf_get_name(args.buf):match("^%a[%w.+-]*://") then
      return
    end
    -- Only restore on the first read of a buffer -- re-reading contents
    -- (:e, autoread, checktime) should never move the cursor
    if vim.b[args.buf].position_restored then
      return
    end
    vim.b[args.buf].position_restored = true
    -- Only restore when a position is actually stored and still valid --
    -- an unset mark is {0,0}, and a stale mark can point past the end of
    -- a file that has since shrunk
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] < 1 or mark[1] > vim.api.nvim_buf_line_count(args.buf) then
      return
    end
    pcall(function()
      vim.cmd('normal! g`"')
    end)
  end,
})

-- Re-opening a buffer closed with :bd counts as a fresh open, so restore the
-- position again then. Buffer variables survive :bd, and BufUnload can't be
-- used here since it also fires on plain :e reloads
vim.api.nvim_create_autocmd("BufDelete", {
  group = restore_group,
  pattern = "*",
  callback = function(args)
    if vim.api.nvim_buf_is_valid(args.buf) then
      vim.b[args.buf].position_restored = nil
    end
  end,
})

return {}
