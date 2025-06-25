return {
  "yetone/avante.nvim",
  enabled = false,
  version = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "MunifTanjim/nui.nvim",
    "saghen/blink.cmp",
    "nvim-telescope/telescope.nvim",
  },
  build = "make",
  opts = {
    hints = { enabled = false },
    auto_suggestions_provider = nil,
    windows = {
      width = 40,
      sidebar_header = {
        enabled = false,
      },
      ask = {},
    },
    selector = {
      provider = "telescope",
    },
    file_selector = {
      provider = "telescope",
    },
    provider = "gemini",
    gemini = {
      model = "gemini-2.5-pro-preview-05-06",
    },
    behaviour = {},
    mappings = {
      --- @class AvanteConflictMappings
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<C-s>",
        insert = "<C-s>",
      },
      cancel = {
        normal = { "<C-c>", "<Esc>", "q" },
        insert = { "<C-c>" },
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        retry_user_request = "r",
        edit_user_request = "e",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
        remove_file = "d",
        add_file = "@",
        close = { "<Esc>", "q" },
        close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
      },
    },
    -- provider = "claude",
    -- claude = {
    --   model = "claude-3-5-sonnet-20241022",
    -- },
  },
  config = function(_, opts)
    require("avante").setup(opts)
  end,
}
