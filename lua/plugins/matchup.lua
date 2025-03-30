return {
  "andymass/vim-matchup",
  init = function()
    vim.g.loaded_matchit = 1 -- Disable matchit because we are using matchup
    vim.g.matchup_transmute_enabled = 1
    vim.g.matchup_surround_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
