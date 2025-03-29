return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    local lspconfig = require("mason-lspconfig")
    lspconfig.setup({capabilities})
    lspconfig.setup_handlers {
      function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          -- Disable semantic tokens/highlighting from LSP
          semanticTokensProvider = false,
          -- Alternatively, you can use this setting which is more commonly supported
          on_attach = function(client, bufnr)
            -- Disable document highlighting
            client.server_capabilities.semanticTokensProvider = nil
          end
        })
      end,
    }
  end
}
