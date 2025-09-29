return {
  "tronikelis/ts-autotag.nvim",
  version = false,
  opts = {
    auto_close = {
      enabled = true,
    },
    auto_rename = {
      enabled = false,
    },
  },
  config = function(_, opts)
    require("ts-autotag").setup(opts)

    vim.keymap.set("n", "<leader>rt", function()
      if not require("ts-autotag").rename() then
        vim.lsp.buf.rename()
      end
    end, { desc = "ts-autotag: rename tag" })
  end,
}
