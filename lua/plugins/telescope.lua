return {
  "nvim-telescope/telescope.nvim",
  version = false,
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", version = false, build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim", version = false },
  },
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = false,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim",
      },
      preview = false,
      layout_strategy = "flex",
      layout_config = {
        height = 0.90,
        width = 0.90,
      },
      prompt_title = false,
      results_title = false,
      preview_title = false,
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
    pickers = {
      lsp_definitions = {
        theme = "cursor",
        prompt_title = false,
        results_title = false,
        preview_title = false,
        borderchars = {
          prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
          results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
      },
      lsp_implementations = {
        theme = "cursor",
        prompt_title = false,
        results_title = false,
        preview_title = false,
        borderchars = {
          prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
          results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
      },
      lsp_references = {
        show_line = false,
        layout_strategy = "vertical",
        columns = 1,
        layout_config = {
          height = 0.95,
          width = 0.90,
        },
        preview = {
          enabled = false,
          treesitter = true,
        },
        prompt_title = false,
        results_title = false,
        preview_title = false,
      },
      buffers = {
        theme = "dropdown",
        ignore_current_buffer = true,
        sort_lastused = true,
        sort_mru = true,
        prompt_title = false,
        results_title = false,
        preview_title = false,
        layout_config = {
          width = 0.8,
          height = 10,
        },
        borderchars = {
          prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
          results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    opts.extensions["ui-select"] = {
      require("telescope.themes").get_cursor({
        borderchars = {
          prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
          results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
      }),
    }
    opts.defaults.mappings = {
      i = {
        ["<c-d>"] = actions.delete_buffer,
        ["<esc>"] = actions.close,
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
      },
      n = { ["<c-d>"] = actions.delete_buffer },
    }

    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    vim.keymap.set("n", "<leader>b", function()
      builtin.buffers({ sort_mru = true })
    end, { desc = "Telescope buffers" })

    vim.keymap.set("n", "<leader>tl", ":Telescope<CR>", { desc = "Telescope global" })
    vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "Find help tags" })
    vim.keymap.set("n", "<leader>tb", builtin.git_branches, { desc = "Git branches picker" })

    -- LSP Related Stuff
    vim.keymap.set("n", "<leader>jd", builtin.lsp_definitions, { desc = "Go to definition" })
    vim.keymap.set("n", "<leader>ji", builtin.lsp_implementations, { desc = "Go to implementation" })
    vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("telescope-cursorline-fix", { clear = true }),
      pattern = { "TelescopePrompt" },
      callback = function()
        vim.opt_local.cursorlineopt = "number"
      end,
    })
  end,
}
