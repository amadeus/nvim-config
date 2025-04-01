return {
  "roryokane/detectindent",
  init = function()
    vim.g.detectindent_max_lines_to_analyse = 1024
  end,
  config = function()
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = vim.api.nvim_create_augroup("detectindent", { clear = true }),
      callback = function()
        vim.cmd("DetectIndent")
      end,
    })
  end,
}
