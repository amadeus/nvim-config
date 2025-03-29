return {
  "mhinz/vim-startify",
  config = function()
    vim.g.startify_custom_header = {
      '                                ______      ',
      '            __                /\\  ____`\\    ',
      '   __   __ /\\_\\    ___ ___    \\ \\ \\___\\ \\   ',
      '  /\\ \\ /\\ \\\\/\\ \\ /` __` __`\\   \\ \\______ \\  ',
      '  \\ \\ \\_/ / \\ \\ \\/\\ \\/\\ \\/\\ \\   \\/_____\\ \\ ',
      '   \\ \\___/   \\ \\_\\ \\_\\ \\_\\ \\_\\    /\\_______\\',
      '    \\/__/     \\/_/\\/_/\\/_/\\/_/    \\/_______/',
      '                                            ',
      '  ==========================================',
      '                                            ',
    }
    vim.g.ascii = {}

    vim.g.startify_custom_footer = vim.fn.map(
      vim.fn["startify#fortune#boxed"]() + vim.g.ascii,
      '"   " .. v:val'
    )

    vim.g.startify_session_autoload = 0 -- Testing out my new session sourcing code
    vim.g.startify_change_to_dir = 1
    vim.g.ctrlp_reuse_window = 'startify'
    vim.g.startify_list_order = { 'bookmarks', 'files' }

    vim.g.startify_skiplist = {
      'COMMIT_EDITMSG',
      vim.env.VIMRUNTIME .. '/doc',
      'bundle/.*/doc',
      '\\.DS_Store'
    }

  vim.g.startify_fortune_use_unicode = 1
  end
}
