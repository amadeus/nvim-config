-- Simple script to fetch and download project specific configurator

local nvim_files = {
  [".nvim.lua"] = {
    url = "https://gist.githubusercontent.com/amadeus/08064a6a20119910009e74a266de851d/raw/f4396c80e95c3cdacbed8ff995a2c7f7b078ba76/.nvim.lua",
    open = true,
  },
}

local gw_files = {
  [".initialize-worktree.fish"] = {
    url = "https://gist.githubusercontent.com/amadeus/ad89b4af913aa2c0811ae4f0964d9979/raw/.initialize-worktree.fish",
    executable = true,
  },
  [".nvim_template.lua"] = {
    url = "https://gist.githubusercontent.com/amadeus/ad89b4af913aa2c0811ae4f0964d9979/raw/.nvim_template.lua",
  },
}

local gw_project_file = ".gw_project"
local gw_create_action = "create-action=../.initialize-worktree.fish"

local function notify(msg, hl)
  vim.api.nvim_echo({ { msg, hl or "None" } }, true, {})
end

local function files_exist(files)
  local existing = {}
  for filename, _ in pairs(files) do
    if vim.fn.filereadable("./" .. filename) == 1 then
      table.insert(existing, filename)
    end
  end
  return existing
end

local function fetch_complete(filename, file_info, code)
  if code ~= 0 then
    notify("Failed to download " .. filename .. " (curl exit code " .. code .. ")", "ErrorMsg")
    return
  end
  if file_info.executable then
    vim.fn.setfperm(filename, "rwxr-xr-x")
  end
  if file_info.open then
    vim.cmd("silent vsplit " .. filename)
  end
  notify("Downloaded " .. filename)
end

local function fetch_file(filename, file_info)
  local url = file_info.url .. "?r=" .. tostring(os.clock())

  vim.fn.jobstart({ "curl", "-sSf", "-o", filename, url, "-L" }, {
    on_exit = function(_, code)
      fetch_complete(filename, file_info, code)
    end,
  })
end

-- Returns false if any of the files already exist and nothing was fetched
local function fetch_files(files)
  local existing = files_exist(files)
  if #existing > 0 then
    notify("Cannot initialize project, some files already exist: " .. table.concat(existing, ", "), "WarningMsg")
    return false
  end

  for filename, file_info in pairs(files) do
    fetch_file(filename, file_info)
  end
  return true
end

local function update_gw_project()
  if vim.fn.filereadable(gw_project_file) ~= 1 then
    notify("No " .. gw_project_file .. " found, skipping create-action (run `gw init` first?)", "WarningMsg")
    return
  end

  local lines = vim.fn.readfile(gw_project_file)
  for _, line in ipairs(lines) do
    if vim.startswith(line, "create-action=") then
      if line == gw_create_action then
        notify(gw_project_file .. " already has: " .. line)
      else
        notify(gw_project_file .. " already has a create-action, modify it manually: " .. line, "WarningMsg")
      end
      return
    end
  end

  table.insert(lines, gw_create_action)
  vim.fn.writefile(lines, gw_project_file)
  notify("Added to " .. gw_project_file .. ": " .. gw_create_action)
end

local function initialize()
  fetch_files(nvim_files)
end

local function initialize_gw()
  if not fetch_files(gw_files) then
    return
  end
  update_gw_project()
end

vim.api.nvim_create_user_command("Initializer", initialize, {})
vim.api.nvim_create_user_command("InitializerGW", initialize_gw, {})
