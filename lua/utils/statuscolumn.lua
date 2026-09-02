local M = {}

local api = vim.api
local foldclosed = vim.fn.foldclosed
local folded_left = "%#Folded# %*"
local signs_left = "%s"
local empty_git_column = " │ "
local gitsigns_statuscolumn
local folded_git_highlights = {}
local cursorline_git_highlights = {}
local number_columns = {}
local cursorline_nr = "CursorLineNrStatusColumn"
local cursorline_nr_inactive = "CursorLineNrInactiveStatusColumn"
local cursorline_sign = "CursorLineSignStatusColumn"

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

  local git = gitsigns_statuscolumn and gitsigns_statuscolumn(buf, lnum)
  if not git or git:match("^%s*$") then
    return empty_git_column
  end

  return " " .. (git:gsub(" $", "")) .. " "
end

local function number_column(win)
  local width = vim.wo[win].numberwidth
  if not number_columns[width] then
    number_columns[width] = "%=%" .. width .. "l"
  end
  return number_columns[width]
end

local function highlight_with_background(group, background, name)
  local source = api.nvim_get_hl(0, { name = group, link = false })
  local background_source = api.nvim_get_hl(0, { name = background, link = false })
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
      overline = rawget(source.cterm, "overline"),
      standout = source.cterm.standout,
      strikethrough = source.cterm.strikethrough,
      altfont = source.cterm.altfont,
      nocombine = source.cterm.nocombine,
    }
  end

  ---@type vim.api.keyset.highlight
  local highlight = {
    fg = source.fg,
    bg = background_source.bg,
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
    overline = rawget(source, "overline"),
    altfont = source.altfont,
    nocombine = source.nocombine,
    ctermfg = source.ctermfg,
    ctermbg = background_source.ctermbg,
    cterm = cterm,
    font = source.font,
    fg_indexed = source.fg_indexed,
    bg_indexed = background_source.bg_indexed,
  }
  api.nvim_set_hl(0, name, highlight)
end

local function git_highlight_with_background(group, background, prefix, highlights)
  if highlights[group] then
    return highlights[group]
  end

  local name = prefix .. group
  highlight_with_background(group, background, name)
  highlights[group] = name
  return name
end

local function refresh_cursorline_highlights()
  highlight_with_background("CursorLineNr", "CursorLine", cursorline_nr)
  highlight_with_background("CursorLineNrInactive", "CursorLine", cursorline_nr_inactive)
  highlight_with_background("CursorLineSign", "CursorLine", cursorline_sign)
end

refresh_cursorline_highlights()

api.nvim_create_autocmd("ColorScheme", {
  group = api.nvim_create_augroup("NvimConfigStatusColumn", { clear = true }),
  desc = "Refresh composed statuscolumn highlights",
  callback = function()
    folded_git_highlights = {}
    cursorline_git_highlights = {}
    refresh_cursorline_highlights()
  end,
})

local function apply_background(statuscolumn, background, git_background, prefix, highlights)
  statuscolumn = statuscolumn:gsub("%%#(GitSigns[^#]+)#", function(group)
    return "%#" .. git_highlight_with_background(group, git_background, prefix, highlights) .. "#"
  end)
  statuscolumn = statuscolumn:gsub("%%%*", function()
    return "%#" .. background .. "#"
  end)
  return "%#" .. background .. "#" .. statuscolumn .. "%*"
end

function M.has_cursorline_background(win)
  local cursorlineopt = vim.wo[win].cursorlineopt
  if cursorlineopt == "both" then
    return true
  end

  cursorlineopt = "," .. cursorlineopt .. ","
  return cursorlineopt:find(",line,", 1, true) ~= nil and cursorlineopt:find(",number,", 1, true) ~= nil
end

---@return string
function M.get()
  local win = statuscolumn_window()
  local show_signs = vim.wo[win].signcolumn ~= "no"
  local show_numbers = vim.wo[win].number or vim.wo[win].relativenumber
  -- If we aren't showing signs or numbers, then we definitely don't render
  -- anything...
  if not show_signs and not show_numbers then
    return ""
  end

  local buf = api.nvim_win_get_buf(win)
  local lnum = vim.v.lnum
  local closed = is_closed_fold(win, lnum)
  local left = closed and folded_left or (show_signs and signs_left or "")
  local number = show_numbers and number_column(win) or ""
  local git = ""
  if vim.bo[buf].buftype ~= "terminal" then
    git = show_signs and git_statuscolumn(buf, lnum) or empty_git_column
  end
  local statuscolumn = left .. number .. git

  if closed then
    -- Folded rows intentionally keep their folded background when they are also the cursor line.
    statuscolumn = apply_background(statuscolumn, "FoldedColumn", "Folded", "FoldedColumn", folded_git_highlights)
  end

  if vim.wo[win].cursorline and api.nvim_win_get_cursor(win)[1] == lnum and M.has_cursorline_background(win) then
    statuscolumn =
      apply_background(statuscolumn, "CursorLine", "CursorLine", "CursorLineColumn", cursorline_git_highlights)
  end

  return statuscolumn
end

return M
