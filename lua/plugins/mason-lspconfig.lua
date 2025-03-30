return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim", "nvim-lspconfig" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "cssls",
        "cssmodules_ls",
        "eslint",
        "lua_ls",
        "ts_ls",
      },
      automatic_installation = true,
    })
    local lspconfig = require("lspconfig")
    lspconfig.ts_ls.setup({
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.cssls.setup({
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.cssmodules_ls.setup({
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.eslint.setup({
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.lua_ls.setup({
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
