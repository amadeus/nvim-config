local function optimize()
  vim.cmd([[
    syntax off
    filetype plugin off
    filetype indent off
    filetype off
    set eventignore=all
  ]])

  vim.api.nvim_echo({ { "Vim is now optimized...", "None" } }, true, {})
end

local function deoptimize()
  vim.cmd([[
    set eventignore=
    syntax on
    filetype plugin on
    filetype indent on
    filetype on
  ]])

  vim.api.nvim_echo({ { "Vim is now deoptimized...", "None" } }, true, {})
end

-- Commands
vim.api.nvim_create_user_command("Optimize", optimize, {})
vim.api.nvim_create_user_command("Deoptimize", deoptimize, {})
