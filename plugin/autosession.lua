-- Prevent duplicate setup
if vim.g.loaded_autosession then
  return
end

local function filenames_to_choices(idx, path)
  local filename = path:match("Session.*%.vim$")
  return "&" .. tostring(idx + 1) .. filename
end

local function source_session(session_file)
  vim.cmd("source " .. vim.fn.fnameescape(session_file))
end

local function detect_session_file()
  local session_files = vim.fn.globpath(".", "Session*.vim", false, true)
  if #session_files == 0 then
    return
  elseif #session_files == 1 then
    source_session(session_files[1])
    return
  end

  local choice_lines = {}
  for i, path in ipairs(session_files) do
    table.insert(choice_lines, filenames_to_choices(i - 1, path))
  end
  table.insert(choice_lines, "&Cancel")

  local cancel_index = #session_files + 1

  local choice = vim.fn.confirm("Would you like to source a Session?", table.concat(choice_lines, "\n"), 1)

  if choice == 0 or choice == cancel_index then
    return
  end

  local selected_file = session_files[choice]

  source_session(selected_file)
end

-- Command
vim.api.nvim_create_user_command("DetectSessions", function()
  detect_session_file()
end, {})

vim.api.nvim_create_user_command("D", function()
  detect_session_file()
end, {})

-- Set flag to avoid re-running
vim.g.loaded_autosession = true
