return {
  "junegunn/goyo.vim",
  version = false,
  cmd = "Goyo",
  init = function()
    vim.g.goyo_margin_top = 5
    vim.g.goyo_margin_bottom = 5
    vim.g.goyo_width = 90

    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("NvimConfigGoyo", { clear = true }),
      pattern = "GoyoEnter",
      desc = "Hide the status column in Goyo padding windows",
      callback = function()
        for _, buf in pairs(vim.t.goyo_pads) do
          vim.wo[vim.fn.bufwinid(buf)].signcolumn = "no"
        end
      end,
    })
  end,
}
