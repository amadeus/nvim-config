return {
  "mhinz/vim-grepper",
  init = function()
    vim.g.grepper = {
      highlight = 1,
      searchreg = 1,
      tools = { "rg", "ag", "ack", "ack-grep", "grep", "findstr", "pt", "sift", "git" }
    }
  end,
  config = function()
    vim.keymap.set("n", "gs", "<Plug>(GrepperOperator)")
    vim.keymap.set("x", "gs", "<Plug>(GrepperOperator)")
  end
}
