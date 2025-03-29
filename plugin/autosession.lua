-- Prevent duplicate setup
if vim.g.did_run_autosession then return end

local timer = 0

local function filenames_to_choices(idx, path)
  local filename = path:match("Session.*%.vim$")
  return "&" .. tostring(idx + 1) .. filename
end

local function source_session(session_file)
  vim.cmd("source " .. vim.fn.fnameescape(session_file))
  timer = 0
end

local function detect_session_file(from_autocmd)
  if timer ~= 0 then return end

  local session_files = vim.fn.globpath(".", "Session*.vim", false, true)
  if #session_files == 0 then return end

  local choice_lines = {}
  for i, path in ipairs(session_files) do
    table.insert(choice_lines, filenames_to_choices(i - 1, path))
  end
  table.insert(choice_lines, "&Cancel")

  local cancel_index = #session_files + 1

  if from_autocmd == 1 then
    vim.api.nvim_clear_autocmds({ group = "autosource", event = "DirChanged" })
  end

  local choice = vim.fn.confirm("Would you like to source a Session?", table.concat(choice_lines, "\n"), 1)

  if choice == 0 or choice == cancel_index then return end

  local selected_file = session_files[choice]

  if from_autocmd == 1 then
    timer = vim.fn.timer_start(300, function() source_session(selected_file) end)
  else
    source_session(selected_file)
  end
end

-- Autocmd setup
vim.api.nvim_create_augroup("autosource", { clear = true })
vim.api.nvim_create_autocmd("DirChanged", {
  group = "autosource",
  callback = function() detect_session_file(1) end
})

-- Command
vim.api.nvim_create_user_command("DetectSessions", function()
  detect_session_file(0)
end, {})

-- Set flag to avoid re-running
vim.g.did_run_autosession = true
