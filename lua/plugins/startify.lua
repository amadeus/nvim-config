return {
  "mhinz/vim-startify",
  version = false,
  config = function()
    vim.g.startify_fortune_use_unicode = 1
    vim.g.startify_custom_header = {
      "                                ______      ",
      "            __                /\\  ____`\\    ",
      "   __   __ /\\_\\    ___ ___    \\ \\ \\___\\ \\   ",
      "  /\\ \\ /\\ \\\\/\\ \\ /` __` __`\\   \\ \\______ \\  ",
      "  \\ \\ \\_/ / \\ \\ \\/\\ \\/\\ \\/\\ \\   \\/._____\\ \\ ",
      "   \\ \\___/   \\ \\_\\ \\_\\ \\_\\ \\_\\    /\\_______\\",
      "    \\/__/     \\/_/\\/_/\\/_/\\/_/    \\/_______/",
      "                                            ",
      "  ==========================================",
      "                                            ",
    }

    local footer = vim.fn["startify#fortune#boxed"]()
    vim.g.startify_custom_footer = vim.fn.map(footer, '"   " .. v:val')

    vim.g.startify_session_autoload = 0 -- Testing out my new session sourcing code
    vim.g.startify_change_to_dir = 1
    vim.g.ctrlp_reuse_window = "startify"
    vim.g.startify_list_order = { "bookmarks", "files" }

    vim.g.startify_skiplist = {
      "COMMIT_EDITMSG",
      vim.env.VIMRUNTIME .. "/doc",
      "bundle/.*/doc",
      "\\.DS_Store",
    }

    vim.g.startify_fortune_use_unicode = 1
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("startify-remove-group", { clear = true }),
      pattern = "Startified",
      callback = function()
        vim.api.nvim_buf_del_keymap(0, "n", "q")
        vim.api.nvim_buf_del_keymap(0, "n", "v")
        vim.keymap.set("n", "v", ":Vaffle<CR>", { buffer = 0, noremap = true, silent = true, desc = "Open Vaffle" })
        vim.keymap.set(
          "n",
          "L",
          ":Lazy update<CR>",
          { buffer = true, silent = true, desc = "Vaffle: Update Lazy plugins" }
        )
      end,
    })
  end,
}
