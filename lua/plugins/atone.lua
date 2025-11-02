return {
  "XXiaoA/atone.nvim",
  -- Shit's kinda sluggish, and navigating around to the different diffs seemed
  -- buggy, so sticking with mundo for now... I just hate the python dependency
  enabled = false,
  version = false,
  lazy = true,
  cmd = "Atone",
  keys = {
    { "<leader>u", "<cmd>Atone toggle<CR>", desc = "Toggle Atone" },
  },
  opts = {
    auto_attach = {
      enabled = true,
      excluded_ft = { "oil" },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = vim.api.nvim_create_augroup("atone-ui", { clear = true }),
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "atone" then
          vim.notify("HI!")
          vim.opt_local.number = false
          vim.opt_local.signcolumn = "no"
        end
      end,
      desc = "Disable UI elements in Atone windows",
    })
  end,
}
