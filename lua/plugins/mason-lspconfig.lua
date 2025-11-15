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
    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Enable file watching for workspace changes There's a chance this could
    -- use a ton of memory or have performance problems, so lets keep an eye on
    -- things in practice
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.didChangeWatchedFiles = {
      dynamicRegistration = true,
      relativePatternSupport = true,
    }

    local servers_to_install = {
      "biome",
      "cssls",
      "cssmodules_ls",
      "eslint",
      "lua_ls",
      "tailwindcss",
      "vtsls",
      "stylelint_lsp",
      -- "ts_ls",
    }

    require("mason-lspconfig").setup({
      -- Don't believe this is needed anymore
      automatic_enable = false,
      ensure_installed = servers_to_install,
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

    local base_config = {
      capabilities = capabilities,
    }

    local custom_configs = {
      biome = {
        capabilities = (function()
          local biome_capabilities = vim.deepcopy(capabilities)
          biome_capabilities.general = vim.tbl_deep_extend("force", biome_capabilities.general or {}, {
            positionEncodings = { "utf-16" },
          })
          return biome_capabilities
        end)(),
      },
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" } },
            telemetry = { enable = false },
          },
        },
      },
    }

    for _, server_name in ipairs(servers_to_install) do
      local server_config = vim.tbl_deep_extend("force", vim.deepcopy(base_config), custom_configs[server_name] or {})
      lspconfig[server_name].setup(server_config)
    end
  end,
}
