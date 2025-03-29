return {
  "roryokane/detectindent",
  config = function()
    vim.g.detectindent_max_lines_to_analyse = 1024

    vim.api.nvim_create_augroup("detectindent", { clear = true })
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = "detectindent",
      callback = function()
        vim.cmd("DetectIndent")
      end,
    })
  end
}
