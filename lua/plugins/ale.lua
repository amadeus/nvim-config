return {
  "dense-analysis/ale",
  version = false,
  init = function()
    -- Disable All Linting
    vim.g.ale_enabled = 0
    vim.g.ale_linters_explicit = 1

    -- Disable all linting triggers 
    vim.g.ale_lint_on_enter = 0
    vim.g.ale_lint_on_text_changed = "never"
    vim.g.ale_lint_on_save = 0
    vim.g.ale_lint_on_insert_leave = 0
    vim.g.ale_lint_on_filetype_changed = 0

    -- Disable all visual indicators for linting 
    -- (using internal neovim apis)
    vim.g.ale_set_signs = 0
    vim.g.ale_set_highlights = 0
    vim.g.ale_warn_about_trailing_whitespace = 0
    vim.g.ale_sign_column_always = 0
    vim.g.ale_virtualtext_cursor = 0
    vim.g.ale_echo_cursor = 0
    vim.g.ale_cursor_detail = 0
    vim.g.ale_hover_cursor = 0
    vim.g.ale_set_balloons = 0

    -- Disable LSP features
    vim.g.ale_disable_lsp = 1
    vim.g.ale_use_neovim_diagnostics_api = 0
    vim.g.ale_completion_enabled = 0

    -- Formatting settings
    vim.g.ale_fix_on_save = 0
    vim.g.ale_save_hidden = 0

    -- Custom Clang flags for Playdate stuff
    -- local clang_flags = "-I /Users/amadeus/Developer/PlaydateSDK/C_API"
    -- vim.g.ale_cpp_clangd_options = clang_flags
    -- vim.g.ale_c_clangd_options = clang_flags
    -- vim.g.ale_c_cc_options = clang_flags
    -- vim.g.ale_cpp_cc_options = clang_flags
  end,
  config = function()
    vim.cmd([[
      function! PrettierdFixer(buffer) abort
        return {
        \   'command': 'prettierd --stdin-filepath %s',
        \   'process_with': 'ale#fixers#prettier#ProcessPrettierDOutput',
        \}
      endfunction
    ]])

    -- Register prettierd with ALE's fixer registry
    vim.fn["ale#fix#registry#Add"](
      "prettierd",
      "PrettierdFixer",
      {
        "javascript",
        "jsx",
        "typescript",
        "tsx",
        "javascriptreact",
        "typescriptreact",
        "css",
        "scss",
        "html",
        "json",
        "jsonc",
        "markdown",
        "yaml",
        "graphql",
      },
      "prettierd - prettier daemon for faster formatting"
    )

    -- Toggle format on save
    function _G.ToggleFormatSave()
      if vim.b.ale_fix_on_save ~= nil then
        vim.b.ale_fix_on_save = not vim.b.ale_fix_on_save
      elseif vim.g.ale_fix_on_save ~= nil then
        vim.b.ale_fix_on_save = not vim.g.ale_fix_on_save
      else
        vim.b.ale_fix_on_save = true
      end

      if vim.b.ale_fix_on_save then
        print("Formatting file on save")
      else
        print("Preserving formatting on save")
      end
    end

    vim.keymap.set("n", "<leader>pf", "<cmd>lua ToggleFormatSave()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>F", "<cmd>ALEFix<CR>", {
      silent = true,
      desc = "Format current buffer",
    })
  end,
}
