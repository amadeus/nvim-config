return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
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
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
          ["<esc>"] = require("telescope.actions").close,
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
      },
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
          width = 0.95,
        },
        prompt_title = false,
        results_title = false,
        preview_title = false,
      },
      git_files = {
        layout = "vertical",
        layout_config = {
          height = 0.95,
          width = 0.95,
        },
        prompt_title = false,
        results_title = false,
        preview_title = false,
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>b", function()
      builtin.buffers({ sort_mru = true })
    end, { desc = "Telescope buffers" })

    vim.keymap.set("n", "<leader>tl", ":Telescope<CR>", { desc = "Telescope global" })
    vim.keymap.set("n", "<leader>tt", builtin.git_files, { desc = "Telescope find git files" })
    vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Telescope find files" })
    vim.keymap.set("n", "<leader>t/", builtin.live_grep, { desc = "Telescope live grep" })
    vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "Find help tags" })

    -- LSP Related Stuff
    vim.keymap.set("n", "<leader>jd", builtin.lsp_definitions, { desc = "Go to definition" })
    vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
  end,
}
