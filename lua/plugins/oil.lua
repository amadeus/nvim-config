local detail = false
return {
  "stevearc/oil.nvim",
  lazy = false,
  opts = {
    default_file_explorer = true,
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    lsp_file_methods = {
      enabled = true,
    },
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },

      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },

      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-r>"] = "actions.refresh",

      ["-"] = { "actions.parent", mode = "n" },
      ["<bs>"] = { "actions.parent", mode = "n" },

      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["~"] = { "actions.cd", mode = "n" },

      ["gs"] = { "actions.change_sort", mode = "n" },
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["gd"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },

      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    use_default_keymaps = false,
  },
  config = function(_, opts)
    require("oil").setup(opts)
    local function oil_alias(args)
      vim.cmd("Oil " .. args.args)
    end
    vim.api.nvim_create_user_command("O", oil_alias, { nargs = "*", desc = "Oil shortcut" })
    vim.api.nvim_create_user_command("F", oil_alias, { nargs = "*", desc = "Oil shortcut" })
  end,
}
