return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    -- neo-tree will lazily load itself (apparently)
    lazy = false,
    opts = {
      filesystem = {
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
          },
        },
      },
      window = {
        position = "current",
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- Create a command :NT that always opens at current working directory
      -- with no arguments given, otherwise it'll pass along all arguments.
      vim.api.nvim_create_user_command("NT", function(cmd)
        if cmd.args == "" then
          vim.cmd("Neotree dir=" .. vim.fn.getcwd())
        else
          vim.cmd("Neotree " .. cmd.args)
        end
      end, { nargs = "*" })
    end,
  },
}
