return {
  "mason-org/mason-lspconfig.nvim",
  version = false,
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
    "pmizio/typescript-tools.nvim",
    -- "yioneko/nvim-vtsls",
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Enable file watching for workspace changes There's a chance this could
    -- use a ton of memory or have performance problems, so lets keep an eye on
    -- things in practice
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.didChangeWatchedFiles = {
      dynamicRegistration = true,
      relativePatternSupport = true,
    }

    -- Force a single position encoding for all servers. Neovim advertises
    -- utf-8/utf-16/utf-32 by default, which lets servers pick different
    -- encodings (tsgo picks utf-8, most others utf-16) and triggers a
    -- checkhealth warning about mixed encodings on the same buffer
    capabilities.general = capabilities.general or {}
    capabilities.general.positionEncodings = { "utf-16" }

    -- Global defaults applied to all LSP servers via the new vim.lsp API.
    -- This replaces the old lspconfig base_config + manual setup loop.
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- Per-server overrides (merged on top of '*' defaults and lsp/*.lua configs)
    vim.lsp.config("oxlint", {
      init_options = {
        settings = {
          typeAware = true,
        },
      },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = { library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" } },
          telemetry = { enable = false },
        },
      },
    })

    -- mason-lspconfig handles ensure_installed + automatically calls
    -- vim.lsp.enable() for all installed servers.
    require("mason-lspconfig").setup({
      automatic_enable = true,
      ensure_installed = {
        "cssls",
        "cssmodules_ls",
        "eslint",
        "lua_ls",
        "tailwindcss",
        "tsgo",
        "oxlint",
        -- "vtsls",
        -- "ts_ls",
        -- "biome",
      },
    })

    -- Generic LspAttach to disable semantic tokens for ALL LSPs
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          -- Not a fan of the lsp semantic tokens, they often update
          -- sluggishly and oftentimes leads to needing to configure more
          -- colors in my theme which I don't want to do
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })
  end,
}
