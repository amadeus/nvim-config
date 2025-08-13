return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = false,
    dependencies = {
      { "nvim-lua/plenary.nvim", version = false },
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    -- neo-tree will lazily load itself (apparently)
    lazy = false,
    opts = {
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            -- Hide number and sign columns in neo-tree buffers
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = "no"
            -- Prevent buffer from appearing in buffer lists and auto-cleanup
            -- Maybe i don't actually need this...
            -- vim.opt_local.buflisted = false
          end,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        window = {
          mappings = {
            -- Really not a fan of their built in fuzzy find, and it messes
            -- with the default vim experience
            ["/"] = "noop",
            ["<space>"] = "noop",
            ["q"] = "noop",
            ["?"] = "noop",
            ["g?"] = "show_help",
            -- Mappings to match more closely with the Vaffle experience...
            ["h"] = "close_node",
            ["l"] = "open",
            -- Remap filter from 'f' to '<c-f>'
            ["f"] = "noop",
            ["<c-f>"] = "filter_on_submit",
          },
        },
      },
      window = {
        position = "current",
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      local function neotree_wrapper_command(cmd)
        if cmd.args == "" then
          vim.cmd("Neotree dir=" .. vim.fn.getcwd())
        else
          vim.cmd("Neotree " .. cmd.args)
        end
      end
      -- Create a command :NT/:V that always opens at current working directory
      -- with no arguments given, otherwise it'll pass along all arguments.
      vim.api.nvim_create_user_command("NT", neotree_wrapper_command, { nargs = "*" })
      vim.api.nvim_create_user_command("V", neotree_wrapper_command, { nargs = "*" })
      vim.api.nvim_create_user_command("F", neotree_wrapper_command, { nargs = "*" })
    end,
  },
}
