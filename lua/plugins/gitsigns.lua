return {
  "lewis6991/gitsigns.nvim",
  version = "*",
  opts = {
    on_attach = function()
      local gitsigns = require("gitsigns")
      -- Navigate hunks
      vim.keymap.set("n", "<D-j>", function()
        gitsigns.nav_hunk("next", { wrap = false, foldopen = false })
      end, { silent = true })
      vim.keymap.set("n", "<D-k>", function()
        gitsigns.nav_hunk("prev", { wrap = false, foldopen = false })
      end, { silent = true })

      -- Stage and reset hunks
      vim.keymap.set("n", "<leader>sh", function()
        gitsigns.stage_hunk()
      end, { silent = true })
      vim.keymap.set("n", "<leader>rh", function()
        gitsigns.reset_hunk()
      end, { silent = true })
    end,
  },
}
