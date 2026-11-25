local group = vim.api.nvim_create_augroup("ProgramResume", { clear = true })
local session_to_restore = vim.g.program_resume_session
local restore = session_to_restore or vim.g.program_resume_file

local function is_file(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "file"
end

if restore and restore ~= "" then
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    once = true,
    nested = true,
    callback = function()
      if is_file(restore) and vim.fn.filereadable(restore) == 1 then
        local path = vim.fn.fnameescape(restore)
        if session_to_restore then
          vim.cmd.source(path)
        else
          vim.cmd.edit(path)
        end
      end
    end,
  })
end

local token = vim.env.OSC7577_TOKEN
if not token or token == "" then
  return
end
vim.env.OSC7577_TOKEN = nil

local pid
local focused_buf, last_file
local last_command, last_cwd

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
  local variable = session and "program_resume_session" or "program_resume_file"
  local command = "let g:" .. variable .. " = " .. vim.fn.string(session or last_file or "")
  local cwd = vim.fn.getcwd()
  if command == last_command and cwd == last_cwd then
    return
  end
  last_command, last_cwd = command, cwd

  local argv = vim.tbl_map(vim.base64.encode, { "nvim", "--cmd", command })
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
      focused_buf = vim.api.nvim_get_current_buf()
      remember_file(focused_buf)
      report()
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
    end
  end,
})
