return {
  "dense-analysis/ale",
  enabled = false,
  init = function()
    -- General ALE settings
    vim.g.ale_lint_on_enter = 0
    vim.g.ale_lint_on_text_changed = "never"
    vim.g.ale_lint_on_save = 0
    vim.g.ale_lint_on_insert_leave = 0
    vim.g.ale_lint_on_filetype_changed = 0
    vim.g.ale_fix_on_save = 0
    vim.g.ale_warn_about_trailing_whitespace = 0
    vim.g.ale_sign_column_always = 1
    vim.g.ale_echo_msg_format = "[%linter%]% (code)% %s"
    vim.g.ale_hover_cursor = 1
    vim.g.ale_set_balloons = 0
    vim.g.ale_echo_delay = 200
    vim.g.ale_virtualtext_cursor = 1
    vim.g.ale_echo_cursor = 0
    vim.g.ale_linter_aliases = { ["typescript.tsx"] = { "typescript", "tsx" } }
    vim.g.ale_save_hidden = 1
    vim.g.ale_use_neovim_diagnostics_api = 0
    vim.g.ale_disable_lsp = 1
    vim.g.ale_set_highlights = 0
    vim.g.ale_set_signs = 0

    -- Linters
    vim.g.ale_linters = {
      javascript = { "eslint", "tsserver" },
      javascriptreact = { "eslint", "tsserver" },
      typescript = { "eslint", "tsserver" },
      typescriptreact = { "eslint", "tsserver" },
    }

    -- Fixers
    vim.g.ale_fixers = {
      javascript = { "prettier" },
      python = { "black", "isort" },
      json = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      tsx = { "prettier" },
      css = { "prettier" },
      stylus = { "prettier" },
      c = { "clang-format" },
    }

    -- Custom Clang flags
    local clang_flags = "-I /Users/amadeus/Developer/PlaydateSDK/C_API"
    vim.g.ale_cpp_clangd_options = clang_flags
    vim.g.ale_c_clangd_options = clang_flags
    vim.g.ale_c_cc_options = clang_flags
    vim.g.ale_cpp_cc_options = clang_flags
  end,
  config = function()
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
  end,
}
