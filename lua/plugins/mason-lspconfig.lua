return {
  "mason-org/mason-lspconfig.nvim",
  version = false,
  dependencies = {
    "mason-org/mason.nvim",
    "nvim-lspconfig",
    "saghen/blink.cmp",
  },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "biome",
        "cssls",
        "cssmodules_ls",
        "eslint",
        "lua_ls",
        -- "ts_ls", -- using typescript_tools instead
      },
      automatic_installation = true,
    })
    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()
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

    -- Biome has a weird thing where it tries to use utf8 instead of utf16 and
    -- it's causing a warning and may actually have other unintended
    -- consequences
    local biome_capabilities = vim.deepcopy(capabilities)
    biome_capabilities.general = vim.tbl_deep_extend("force", biome_capabilities.general or {}, {
      positionEncodings = { "utf-16" },
    })

    lspconfig.biome.setup({
      capabilities = biome_capabilities,
      on_attach = function(client)
        -- Disable document highlighting
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    lspconfig.tailwindcss.setup({
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
