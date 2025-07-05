local M = {}

--- Returns a custom, configurable string for a closed fold.
--- `  ── ▸ 7 lines: function foo() ───────────────────────`
---@return string
function M.text()
  local first_indent_char = " "
  local middle_indent_char = "─"
  local pre_marker_char = " "
  local fold_marker = "▸"

  local first_line = vim.fn.getline(vim.v.foldstart)
  local indent_len = vim.fn.indent(vim.v.foldstart)
  local preview_content = vim.fn.trim(first_line)

  local display_indent = ""
  if indent_len > 0 then
    if indent_len == 1 then
      display_indent = first_indent_char
    else
      display_indent = first_indent_char .. string.rep(middle_indent_char, indent_len - 2) .. pre_marker_char
    end
  end

  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local text = string.format("%s%s %d lines: %s", display_indent, fold_marker, line_count, preview_content)

  return text .. " "
end

return M
