return {
  "carlos-algms/agentic.nvim",
  event = "VeryLazy",
  opts = {
    -- Available by default: "claude-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp"
    provider = "claude-acp", -- setting the name here is all you need to get started

    keymaps = {
      widget = {
        change_mode = {
          {
            "<d-tab>",
            mode = { "i", "n", "v" }, -- Specify modes for this keybinding
          },
        },
      },
      prompt = {
        submit = {
          {
            "<c-cr>",
            mode = { "n", "v", "i" },
          },
        },
      },
    },
  },

  -- these are just suggested keymaps; customize as desired
  keys = {
    {
      "<leader>cc",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "v", "i" },
      desc = "Toggle Agentic Chat",
    },
    {
      "<C->>",
      function()
        require("agentic").add_selection_or_file_to_context()
      end,
      mode = { "n", "v" },
      desc = "Add file or selection to Agentic to Context",
    },
    {
      "<C-,>",
      function()
        require("agentic").new_session()
      end,
      mode = { "n", "v", "i" },
      desc = "New Agentic Session",
    },
  },
}
