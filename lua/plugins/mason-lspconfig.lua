return {
  "williamboman/mason-lspconfig.nvim",
  version = "*",
  dependencies = {
    {
      -- Temp fork since mason.vim is (keep in sync with plugin/mason.lua)
      "williamboman/mason.nvim",
      url = "https://github.com/iguanacucumber/mason.nvim",
      branch = "next",
    },
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
        "ts_ls",
      },
      automatic_installation = true,
    })
    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    lspconfig.cssls.setup({ capabilities = capabilities })
    lspconfig.cssmodules_ls.setup({ capabilities = capabilities })
    lspconfig.eslint.setup({ capabilities = capabilities })
    lspconfig.biome.setup({ capabilities = capabilities })
    lspconfig.tailwindcss.setup({ capabilities = capabilities })
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
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
