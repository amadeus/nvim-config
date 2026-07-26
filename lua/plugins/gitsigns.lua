return {
  "lewis6991/gitsigns.nvim",
  version = false,
  opts = {
    -- NOTE(amadeus): Don't really like the default `~` for
    -- changedelete...
    signs = { changedelete = { text = "╋" } },
    signs_staged = { changedelete = { text = "╋" } },
    update_debounce = 16,
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      -- Navigate hunks
      vim.keymap.set("n", "<D-j>", function()
        gitsigns.nav_hunk("next", { wrap = false, foldopen = false })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<D-J>", function()
        gitsigns.nav_hunk("next", { wrap = false, foldopen = false, target = "all" })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<D-k>", function()
        gitsigns.nav_hunk("prev", { wrap = false, foldopen = false })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<D-K>", function()
        gitsigns.nav_hunk("prev", { wrap = false, foldopen = false, target = "all" })
      end, { buffer = bufnr, silent = true })

      -- Stage and reset hunks
      vim.keymap.set("n", "<leader>sh", function()
        gitsigns.stage_hunk()
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("v", "<leader>sh", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<leader>rh", function()
        gitsigns.reset_hunk()
      end, { buffer = bufnr, silent = true })
      -- By adding this noop mapping, we make sure to never fall back into the
      -- default `s` mapping if there's too much of a delay, which replaces the
      -- current character or selection and enters insert mode
      vim.keymap.set({ "n", "v" }, "<leader>s", "<Nop>", { buffer = bufnr, silent = true })
    end,

    preview_config = {
      border = "rounded",
    },
  },
}
