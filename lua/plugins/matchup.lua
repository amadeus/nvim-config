return {
  "andymass/vim-matchup",
  version = false,
  init = function()
    vim.g.loaded_matchit = 1 -- Disable matchit because we are using matchup
    vim.g.matchup_transmute_enabled = 1
    vim.g.matchup_surround_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = {
      method = "popup",
      border = "none",
      highlight = "OffscreenPopup",
      fullwidth = 1,
    }
    -- fullwidth sizes the float to winwidth + strlen(line("$")), so in the rightmost split Neovim shifts it left to fit
    -- on screen, misaligning it with the window's statuscolumn. Clamp it to the parent window's width, and again on
    -- resize since matchup keeps the popup open without resizing it.
    local popup
    local function clamp_popup()
      if not popup or not vim.api.nvim_win_is_valid(popup) then
        return
      end
      local parent = vim.api.nvim_win_get_config(popup).win
      if parent and vim.api.nvim_win_is_valid(parent) then
        vim.api.nvim_win_set_width(popup, vim.api.nvim_win_get_width(parent))
      end
    end

    local group = vim.api.nvim_create_augroup("NvimConfigMatchupOffscreen", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "MatchupOffscreenEnter",
      desc = "Clamp matchup offscreen popup to its window width",
      callback = function()
        popup = vim.api.nvim_get_current_win()
        clamp_popup()
      end,
    })
    vim.api.nvim_create_autocmd("WinResized", {
      group = group,
      desc = "Keep matchup offscreen popup clamped to its window width",
      callback = clamp_popup,
    })
  end,
}
