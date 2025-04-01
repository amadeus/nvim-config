-- Simple script to fetch and download general project configs for CRA JS
-- projects

-- Avoid re-running
if vim.g.did_run_initializer then
  return
end

local files = {
  [".prettierrc"] = {
    url = "https://gist.github.com/amadeus/b6d360e7e6823ab226be85dc0c1fae29/raw",
  },
  [".lvimrc.lua"] = {
    url = "https://gist.github.com/amadeus/08064a6a20119910009e74a266de851d/raw",
    open = true,
  },
}

local filenames = vim.tbl_keys(files)

local function files_exist()
  local existing = {}
  for _, filename in ipairs(filenames) do
    if vim.fn.filereadable("./" .. filename) == 1 then
      table.insert(existing, filename)
    end
  end
  return existing
end

local function fetch_complete(filename)
  local file_info = files[filename]
  if file_info.open then
    vim.cmd("silent vsplit " .. filename)
  end
end

local function fetch_file(filename)
  local file_info = files[filename]
  local url = file_info.url .. "?r=" .. tostring(os.clock())

  vim.fn.jobstart({ "curl", "-o", filename, url, "-L" }, {
    on_exit = function()
      fetch_complete(filename)
    end,
  })
end

local function fetch_files()
  local existing = files_exist()
  if #existing > 0 then
    vim.api.nvim_echo(
      {
        {
          "Cannot initialize project, some files already exist: " .. table.concat(existing, ", "),
          "WarningMsg",
        },
      },
      true,
      {}
    )
    return
  end

  for _, filename in ipairs(filenames) do
    fetch_file(filename)
  end
end

vim.api.nvim_create_user_command("Initializer", fetch_files, {})

vim.g.did_run_initializer = true
