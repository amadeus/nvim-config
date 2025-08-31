return {
  "dmtrKovalenko/fff.nvim",
  version = false,
  build = "cargo build --release",
  opts = {
    prompt = " ",
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("fff").find_files() -- or find_in_git_root() if you only want git files
      end,
      desc = "Open FFFile picker",
    },
  },
}
