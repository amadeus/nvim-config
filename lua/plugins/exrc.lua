return {
  -- "jedrzejboczar/exrc.nvim",
  "amadeus/exrc.nvim",
  version = false,
  opts = {
    exrc_name = ".nvim.lua",
    on_vim_enter = true,
    on_dir_changed = {
      enabled = true,
      use_ui_select = true,
    },
    trust_on_write = true,
  },
}
