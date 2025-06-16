---@diagnostic disable-next-line: unused-local, unused-function
local function jump_to_source_definition()
  local vtsls_commands = require("vtsls").commands
  if vtsls_commands and vtsls_commands.goto_source_definition then
    local current_winnr = vim.api.nvim_get_current_win()
    ---@diagnostic disable-next-line: unused-function
    local on_resolve = function() end
    ---@diagnostic disable-next-line: unused-function
    local on_reject = function(err)
      vim.notify("VTSLS: Error going to source definition: " .. vim.inspect(err), vim.log.levels.ERROR)
    end
    vtsls_commands.goto_source_definition(current_winnr, on_resolve, on_reject)
  else
    vim.notify("VTSLS 'goto_source_definition' command not available.", vim.log.levels.WARN)
  end
end

return {
  "mason-org/mason-lspconfig.nvim",
  version = false,
  dependencies = {
    "mason-org/mason.nvim",
    "nvim-lspconfig",
    "saghen/blink.cmp",
    -- "yioneko/nvim-vtsls",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    -- require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    require("mason-lspconfig").setup({
      automatic_enable = true,
      automatic_installation = true,
      ensure_installed = {
        "biome",
        "cssls",
        "cssmodules_ls",
        "eslint",
        "lua_ls",
        -- "vtsls",
      },
      handlers = {
        -- Default handler for servers -- lets pass along capabilities and
        -- disable semantic tokens
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = function(client)
              client.server_capabilities.semanticTokensProvider = nil
            end,
          })
        end,
        -- Biome has a weird thing where it tries to use utf8 instead of utf16 and
        -- it's causing a warning and may actually have other unintended
        -- consequences
        ["biome"] = function()
          local biome_capabilities = vim.deepcopy(capabilities)
          biome_capabilities.general = vim.tbl_deep_extend("force", biome_capabilities.general or {}, {
            positionEncodings = { "utf-16" },
          })
          lspconfig.biome.setup({
            capabilities = biome_capabilities,
            on_attach = function(client)
              client.server_capabilities.semanticTokensProvider = nil
            end,
          })
        end,
        -- Specific handler for lua_ls -- mostly stuff to make the dev
        -- experience with neovim plugins better
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = function(client)
              client.server_capabilities.semanticTokensProvider = nil
            end,
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                  },
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          })
        end,
      },
    })
  end,
}
