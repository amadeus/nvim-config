return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "debugloop/telescope-undo.nvim",
  },
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = false,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      undo = {},
    },
    defaults = {
      prompt_prefix = "➤ ",
      selection_caret = "➤ ",
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
    },
    pickers = {
      lsp_definitions = {
        theme = "cursor",
        prompt_title = false,
        results_title = false,
        preview_title = false,
      },
      lsp_references = {
        theme = "cursor",
        prompt_title = false,
        results_title = false,
        preview_title = false,
      },
      buffers = {
        prompt_title = false,
        results_title = false,
        preview_title = false,
        theme = "dropdown",
        layout_config = {
          width = 0.8,
          height = 10,
        },
      },
      find_files = {
        layout = "vertical",
        layout_config = {
          height = 0.95,
          width = 0.90,
        },
        prompt_title = false,
        results_title = false,
        preview_title = false,
      },
      git_files = {
        layout = "vertical",
        layout_config = {
          height = 0.95,
          width = 0.90,
        },
        prompt_title = false,
        results_title = false,
        preview_title = false,
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    opts.defaults.mappings = {
      i = {
        ["<c-d>"] = actions.delete_buffer,
        ["<esc>"] = actions.close,
      },
      n = { ["<c-d>"] = actions.delete_buffer },
    }

    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("undo")

    vim.keymap.set("n", "<leader>b", function()
      builtin.buffers({ sort_mru = true })
    end, { desc = "Telescope buffers" })

    vim.keymap.set("n", "<leader>tl", ":Telescope<CR>", { desc = "Telescope global" })
    vim.keymap.set("n", "<leader>tt", function()
      local ok = pcall(builtin.git_files)
      if not ok then
        builtin.find_files()
      end
    end, { desc = "Telescope find files (git or all)" })
    vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Telescope find files" })
    vim.keymap.set("n", "<leader>t/", builtin.live_grep, { desc = "Telescope live grep" })
    vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "Find help tags" })

    -- LSP Related Stuff
    vim.keymap.set("n", "<leader>jd", builtin.lsp_definitions, { desc = "Go to definition" })
    vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })

    -- Telescope Undo Plugin
    -- Not sure I like this plugin atm, it kinda fucks with my visualization of
    -- history a bit I think..., and doesn't feel totally explorable
    vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")

    -- Quick hack until telescope/plenary support 0.11 border = "rounded"
    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopeFindPre",
      callback = function()
        vim.opt_local.winborder = "none"
        vim.api.nvim_create_autocmd("WinLeave", {
          once = true,
          callback = function()
            vim.opt_local.winborder = "rounded"
          end,
        })
      end,
    })
  end,
}
