return {
  "wellle/targets.vim",
  -- TODO: Figure out if I even need something like this anymore, Treesitter
  -- stuff may supersede it...
  version = false,
  config = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("targets_tweaks", { clear = true }),
      pattern = "targets#mappings#user",
      callback = function()
        vim.fn["targets#mappings#extend"]({
          a = { argument = { { o = "[{([]", c = "[])}]", s = "," } } },
        })
      end,
    })
  end,
}
