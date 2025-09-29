return {
  "pmizio/typescript-tools.nvim",
  url = "https://github.com/Yuki-bun/typescript-tools.nvim/",
  branch = "refac-use_native_lsp_api",
  version = false,
  dependencies = { "neovim/nvim-lspconfig" },
  opts = {
    on_init = function(client)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
