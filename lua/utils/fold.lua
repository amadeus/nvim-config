local M = {}

local function escape_statuscolumn_text(text)
  return text:gsub("%%", "%%%%")
end

--- Returns a custom, configurable string for a closed fold.
--- `  ── ▸ 7 lines: function foo() ───────────────────────`
---@return string
function M.text()
  local first_indent_char = " "
  local middle_indent_char = "─"
  local pre_marker_char = " "
  local fold_marker = ""

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

--- Returns the statuscolumn format to use for the current screen line.
---@return string
function M.statuscolumn()
  if vim.v.virtnum ~= 0 or vim.fn.foldclosed(vim.v.lnum) ~= vim.v.lnum then
    return "%s%C%l "
  end

  local prefix = vim.api.nvim_eval_statusline("%s%C", {
    winid = vim.api.nvim_get_current_win(),
    use_statuscol_lnum = vim.v.lnum,
  }).str

  return "%#FoldedColumn#" .. escape_statuscolumn_text(prefix) .. "%$FoldedColumn$%l "
end

return M
