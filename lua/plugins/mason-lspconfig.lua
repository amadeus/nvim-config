return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim", "nvim-lspconfig", "saghen/blink.cmp" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "biome",
        "cssls",
        "cssmodules_ls",
        "eslint",
        "lua_ls",
        "ts_ls",
      },
      automatic_installation = true,
    })
    local lspconfig = require("lspconfig")
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.cssls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.cssmodules_ls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.biome.setup({
      capabilities = capabilities,
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
      settings = {
        Lua = {
          runtime = {
            -- Set Lua runtime version
            version = "LuaJIT",
          },
          workspace = {
            -- Include Neovim runtime files
            -- library = vim.api.nvim_get_runtime_file("", true),
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
            },
          },
          telemetry = {
            -- Disable telemetry
            enable = false,
          },
        },
      },
    })
  end,
}
