return {
  "pasky/claude.vim",
  version = false,
  enabled = false,
  init = function()
    vim.g.claude_map_implement = "<Leader>ci"
    vim.g.claude_map_open_chat = "<Leader>cc"
    vim.g.claude_map_send_chat_message = "<C-CR>"
    vim.g.claude_map_cancel_response = "<Leader>cx"
  end,
}
