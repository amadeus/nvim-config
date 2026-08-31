local M = {}

local api = vim.api
local foldclosed = vim.fn.foldclosed
local folded_left = "%#Folded# %*"
local signs_left = "%s"
local number_column = "%=%l "
local empty_git_column = "  "
local gitsigns_statuscolumn
local folded_git_highlights = {}

api.nvim_create_autocmd("ColorScheme", {
  group = api.nvim_create_augroup("NvimConfigStatusColumn", { clear = true }),
  desc = "Refresh folded Git sign highlights",
  callback = function()
    folded_git_highlights = {}
  end,
})

local function statuscolumn_window()
  local win = vim.g.statusline_winid
  return type(win) == "number" and api.nvim_win_is_valid(win) and win or api.nvim_get_current_win()
end

local function is_closed_fold(win, lnum)
  if vim.v.virtnum ~= 0 then
    return false
  end

  if win == api.nvim_get_current_win() then
    return foldclosed(lnum) == lnum
  end

  return api.nvim_win_call(win, function()
    return foldclosed(lnum) == lnum
  end)
end

local function git_statuscolumn(buf, lnum)
  if vim.v.virtnum ~= 0 then
    return empty_git_column
  end

  if not gitsigns_statuscolumn then
    local gitsigns = package.loaded["gitsigns"]
    gitsigns_statuscolumn = type(gitsigns) == "table" and gitsigns.statuscolumn or nil
  end

  return gitsigns_statuscolumn and gitsigns_statuscolumn(buf, lnum) or empty_git_column
end

local function folded_git_highlight(group)
  if folded_git_highlights[group] then
    return folded_git_highlights[group]
  end

  local name = "FoldedColumn" .. group
  local source = api.nvim_get_hl(0, { name = group, link = false })
  ---@type vim.api.keyset.highlight_cterm?
  local cterm
  if source.cterm then
    cterm = {
      reverse = source.cterm.reverse,
      bold = source.cterm.bold,
      italic = source.cterm.italic,
      underline = source.cterm.underline,
      undercurl = source.cterm.undercurl,
      underdouble = source.cterm.underdouble,
      underdotted = source.cterm.underdotted,
      underdashed = source.cterm.underdashed,
      standout = source.cterm.standout,
      strikethrough = source.cterm.strikethrough,
      altfont = source.cterm.altfont,
      nocombine = source.cterm.nocombine,
    }
  end

  ---@type vim.api.keyset.highlight
  local highlight = {
    fg = source.fg,
    bg = api.nvim_get_hl(0, { name = "Folded", link = false }).bg,
    sp = source.sp,
    blend = source.blend,
    bold = source.bold,
    italic = source.italic,
    reverse = source.reverse,
    standout = source.standout,
    strikethrough = source.strikethrough,
    underline = source.underline,
    undercurl = source.undercurl,
    underdouble = source.underdouble,
    underdotted = source.underdotted,
    underdashed = source.underdashed,
    altfont = source.altfont,
    nocombine = source.nocombine,
    ctermfg = source.ctermfg,
    ctermbg = source.ctermbg,
    cterm = cterm,
    font = source.font,
    fg_indexed = source.fg_indexed,
    bg_indexed = source.bg_indexed,
  }
  api.nvim_set_hl(0, name, highlight)
  folded_git_highlights[group] = name
  return name
end

local function apply_folded_background(statuscolumn)
  statuscolumn = statuscolumn:gsub("%%#(GitSigns[^#]+)#", function(group)
    return "%#" .. folded_git_highlight(group) .. "#"
  end)
  statuscolumn = statuscolumn:gsub("%%%*", function()
    return "%#FoldedColumn#"
  end)
  return "%#FoldedColumn#" .. statuscolumn .. "%*"
end

---@return string
function M.get()
  local win = statuscolumn_window()
  local buf = api.nvim_win_get_buf(win)
  local lnum = vim.v.lnum
  local closed = is_closed_fold(win, lnum)
  local show_signs = vim.wo[win].signcolumn ~= "no"
  local show_numbers = vim.wo[win].number or vim.wo[win].relativenumber
  local left = closed and folded_left or (show_signs and signs_left or "")
  local number = show_numbers and number_column or ""
  local git = show_signs and git_statuscolumn(buf, lnum) or ""
  local statuscolumn = left .. number .. git

  if not closed then
    return statuscolumn
  end

  return apply_folded_background(statuscolumn)
end

return M
