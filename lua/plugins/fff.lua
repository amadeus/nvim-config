return {
  "dmtrKovalenko/fff.nvim",
  url = "https://github.com/amadeus/fff.nvim",
  branch = "input-border-tweak",
  version = false,
  build = "cargo build --release",
  opts = {
    prompt = " ",
    preview = {
      line_numbers = true,
    },
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
