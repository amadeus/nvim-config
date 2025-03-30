return {
  "wellle/targets.vim",
  config = function()
    vim.api.nvim_create_augroup("targets_tweaks", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "targets_tweaks",
      pattern = "targets#mappings#user",
      callback = function()
        vim.fn["targets#mappings#extend"]({
          a = { argument = { { o = "[{([]", c = "[])}]", s = "," } } },
        })
      end,
    })
  end,
}
