return {
  "neovim/nvim-lspconfig",
  config = function()
    require("lspconfig").lua_ls.setup({
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
              "${3rd}/luv/library"
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
