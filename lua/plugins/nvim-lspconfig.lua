return {
  "neovim/nvim-lspconfig",
  version = false,
  -- configuration of this is handled in `mason-lspconfig`
  -- config = function()
  --   local lspconfig = require("lspconfig")
  --   lspconfig.ts_ls.setup({})
  --   lspconfig.eslint.setup({})
  --   lspconfig.lua_ls.setup({
  --     settings = {
  --       Lua = {
  --         runtime = {
  --           -- Set Lua runtime version
  --           version = "LuaJIT",
  --         },
  --         workspace = {
  --           -- Include Neovim runtime files
  --           -- library = vim.api.nvim_get_runtime_file("", true),
  --           library = {
  --             vim.env.VIMRUNTIME,
  --             "${3rd}/luv/library",
  --           },
  --         },
  --         telemetry = {
  --           -- Disable telemetry
  --           enable = false,
  --         },
  --       },
  --     },
  --   })
  -- end,
}
