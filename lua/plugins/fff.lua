return {
  "dmtrKovalenko/fff.nvim",
  -- version = "*",
  version = false,
  build = function()
    local done = false
    local download_error = nil

    require("fff.download").download_binary(function(success, err)
      if not success then
        download_error = err or "unknown error"
      end
      done = true
    end)

    local ok, wait_err = vim.wait(1000 * 60 * 2, function()
      return done
    end, 100)

    if not ok and wait_err == -2 then
      error("fff.nvim: download_binary timed out")
    end

    if download_error then
      error("Failed to download fff.nvim binary: " .. download_error)
    end
  end,
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
