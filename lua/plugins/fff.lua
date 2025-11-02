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
  config = function(_, opts)
    require("fff").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("fff-cursorline-fix", { clear = true }),
      pattern = { "fff_input" },
      callback = function()
        vim.opt_local.cursorlineopt = "number"
      end,
    })
  end,
}
