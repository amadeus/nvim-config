local M = {}

local function is_file(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "file"
end

-- Called by the private -S script after init.lua and before UIEnter.
function M.restore(kind, path)
  local snacks = package.loaded.snacks
  if snacks then
    snacks.config.dashboard.enabled = false
  end
  if path ~= "" and is_file(path) and vim.fn.filereadable(path) == 1 then
    if kind == "session" then
      vim.cmd.source(vim.fn.fnameescape(path))
    else
      vim.cmd.edit(vim.fn.fnameescape(path))
    end
  end
end

local token = vim.env.OSC7577_TOKEN
if not token or token == "" then
  return M
end
vim.env.OSC7577_TOKEN = nil

local group = vim.api.nvim_create_augroup("ProgramResume", { clear = true })
local directory = vim.fs.joinpath(vim.fn.stdpath("state"), "program-resume")
local script = vim.fs.joinpath(directory, ("%d-%d.lua"):format(vim.fn.getpid(), vim.uv.hrtime()))
local pid, tui_channel
local focused_buf, last_file
local last_kind, last_path, last_cwd

local function prune_old_scripts()
  local cutoff = os.time() - 30 * 24 * 60 * 60
  for name, entry_type in vim.fs.dir(directory) do
    local owner = tonumber(name:match("^(%d+)%-%d+%.lua$") or "")
    if owner and entry_type == "file" then
      local path = vim.fs.joinpath(directory, name)
      local stat = vim.uv.fs_stat(path)
      if stat and stat.mtime.sec < cutoff and not vim.uv.kill(owner, 0) then
        vim.uv.fs_unlink(path)
      end
    end
  end
end

local function save_target(kind, path)
  local line = ('require("config.program-resume").restore(%q, %q)\n'):format(kind, path)
  local temp = script .. ".tmp"
  vim.fn.mkdir(directory, "p", "448") -- 0700
  local fd = assert(vim.uv.fs_open(temp, "w", 384)) -- 0600
  local bytes, err = vim.uv.fs_write(fd, line, 0)
  local closed, close_err = vim.uv.fs_close(fd)
  assert(bytes == #line, err or "Incomplete write")
  assert(closed, close_err)
  assert(vim.uv.fs_rename(temp, script))
end

local function sequence(fields)
  local body = ("pid=%d:time=%d:%s"):format(pid, os.time(), fields)
  local mac = vim.fn.sha256(body .. ":" .. token)
  return "\027]7577;" .. body .. ":mac=" .. mac .. "\027\\"
end

local function report()
  if not pid then
    return
  end

  local session = vim.g.this_obsession
  local kind, path = session and "session" or "file", session or last_file or ""
  if kind ~= last_kind or path ~= last_path then
    local ok, err = pcall(save_target, kind, path)
    if not ok then
      vim.uv.fs_unlink(script .. ".tmp")
      last_kind, last_path, last_cwd = nil, nil, nil
      vim.api.nvim_ui_send(sequence("clear=1"))
      vim.notify_once("Could not save Neovim resume target: " .. tostring(err), vim.log.levels.WARN)
      return
    end
    last_kind, last_path = kind, path
  end
  local cwd = vim.fn.getcwd()
  if cwd == last_cwd then
    return
  end
  last_cwd = cwd

  local argv = vim.tbl_map(vim.base64.encode, { "nvim", "-S", script })
  local record = sequence("argv=" .. table.concat(argv, ",") .. ":cwd=" .. vim.base64.encode(cwd))
  if #record > 2048 then
    -- Terminals with the minimum OSC 7577 buffer may ignore the new record and keep the old one.
    vim.api.nvim_ui_send(sequence("clear=1"))
  end
  vim.api.nvim_ui_send(record)
end

local function remember_file(buf)
  if vim.bo[buf].buftype == "" then
    local path = vim.api.nvim_buf_get_name(buf)
    if path ~= "" and not path:match("^%a[%w.+-]*://") and is_file(path) then
      last_file = path
    end
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost", "BufWritePost" }, {
  group = group,
  callback = function(ev)
    if ev.event == "BufEnter" then
      focused_buf = ev.buf
    end
    if ev.buf == focused_buf then
      remember_file(ev.buf)
      report()
    end
  end,
})

vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  callback = function()
    local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
    if client and client.name == "nvim-tui" and client.attributes.pid == vim.uv.os_getppid() then
      -- The foreground process on the terminal is the TUI, which starts the editor as its child.
      pid = client.attributes.pid
      tui_channel = vim.v.event.chan
      focused_buf = vim.api.nvim_get_current_buf()
      remember_file(focused_buf)
      report()
      if last_kind then
        prune_old_scripts()
      end
    end
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  group = group,
  callback = function()
    -- Losing the TUI on a Rex shutdown can leave v:dying at zero.
    if vim.v.event.chan == tui_channel then
      pid = nil
    end
  end,
})

vim.api.nvim_create_autocmd({ "DirChanged", "SessionLoadPost" }, { group = group, callback = report })
vim.api.nvim_create_autocmd("User", { group = group, pattern = "Obsession", callback = report })
-- Obsession refreshes 'readonly' after every :Obsession command, including pause and delete.
vim.api.nvim_create_autocmd("OptionSet", { group = group, pattern = "readonly", callback = report })
vim.api.nvim_create_autocmd("VimResume", {
  group = group,
  callback = function()
    last_cwd = nil
    report()
  end,
})
vim.api.nvim_create_autocmd("VimLeave", {
  group = group,
  callback = function()
    if pid and vim.v.dying == 0 then
      vim.api.nvim_ui_send(sequence("clear=1"))
      vim.cmd.redraw()
      vim.uv.fs_unlink(script)
    end
  end,
})

return M
