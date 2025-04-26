return {
  -- Temporarily using my fork with a bugfix, until hopefully
  -- https://github.com/andymass/vim-matchup/pull/387 is merged
  "amadeus/vim-matchup",
  -- "andymass/vim-matchup",
  branch = "bugfix/winbar-compatibility",
  version = false,
  init = function()
    vim.g.loaded_matchit = 1 -- Disable matchit because we are using matchup
    vim.g.matchup_transmute_enabled = 1
    vim.g.matchup_surround_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
