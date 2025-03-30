return {
  "neovim/nvim-lspconfig",
  config = function()
    -- lspconfig.lua_ls.setup({
    --   settings = {
    --     Lua = {
    --       runtime = {
    --         -- Set Lua runtime version
    --         version = "LuaJIT",
    --       },
    --       diagnostics = {
    --         -- Recognize 'vim' as a global
    --         globals = { "vim" },
    --       },
    --       workspace = {
    --         -- Include Neovim runtime files
    --         library = vim.api.nvim_get_runtime_file("", true),
    --       },
    --       telemetry = {
    --         -- Disable telemetry
    --         enable = false,
    --       },
    --     },
    --   },
    -- })
  end,
}
