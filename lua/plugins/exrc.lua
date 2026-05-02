return {
  -- "jedrzejboczar/exrc.nvim",
  "amadeus/exrc.nvim",
  branch = "fork",
  version = false,
  opts = {
    exrc_name = ".nvim.lua",
    on_vim_enter = true,
    on_dir_changed = {
      enabled = true,
      use_ui_select = true,
    },
    trust_on_write = true,
    commands = {
      instant_edit_single = true,
    },
  },
  config = function(_, opts)
    require("exrc").setup(opts)
    vim.api.nvim_create_user_command("E", function(cmd_opts)
      vim.cmd("ExrcLoad" .. (cmd_opts.bang and "!" or ""))
    end, { bang = true, desc = "ExrcLoad shortcut" })
  end,
}
