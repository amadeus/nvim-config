return {
  "pmizio/typescript-tools.nvim",
  version = false,
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    on_init = function(client)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
