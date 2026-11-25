local M = {}

local api = vim.api
local foldclosed = vim.fn.foldclosed
local diff_gutter = require("utils.diff-gutter")
local folded_left = "%#Folded# %*"
local signs_left = "%s"
local empty_git_column = "│"
local gitsigns_statuscolumn
local folded_git_highlights = {}
local cursorline_git_highlights = {}
local number_columns = {}
local cursorline_nr = "CursorLineNrStatusColumn"
local cursorline_nr_inactive = "CursorLineNrInactiveStatusColumn"
local cursorline_sign = "CursorLineSignStatusColumn"

local function git_statuscolumn(buf, lnum)
  if not gitsigns_statuscolumn then
    local gitsigns = package.loaded["gitsigns"]
    gitsigns_statuscolumn = type(gitsigns) == "table" and gitsigns.statuscolumn or nil
  end

  local git = gitsigns_statuscolumn and gitsigns_statuscolumn(buf, lnum)
  -- Gitsigns emits unstaged signs first. Keep one highlighted sign when both land on the same row.
  return (git and git:match("^.-%%%*")) or empty_git_column
end

local function number_column(width)
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

local function sign_highlight_with_background(group, background, prefix, highlights)
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
    return "%#" .. sign_highlight_with_background(group, git_background, prefix, highlights) .. "#"
  end)
  statuscolumn = statuscolumn:gsub("%%%*", function()
    return "%#" .. background .. "#"
  end)
  return "%#" .. background .. "#" .. statuscolumn .. "%*"
end

-- nvim_get_hl resolves links in the rendering window. A missing local
-- definition inherits the resolved group from the global namespace.
local function window_highlight(ctx, group)
  local opts = { name = group, link = false }
  if ctx.ns > 0 then
    local hl = api.nvim_get_hl(ctx.ns, opts)
    -- A winhighlight link can end at the original group's global definition.
    if hl.link then
      return api.nvim_get_hl(0, opts)
    end
    if next(hl) then
      return hl
    end
    -- An explicitly empty local group suppresses the global definition.
    -- A targeted lookup returns {} for both an empty and a missing group.
    ctx.local_groups = ctx.local_groups or api.nvim_get_hl(ctx.ns, {})
    local id = vim.fn.synIDtrans(vim.fn.hlID(group))
    local local_def = ctx.local_groups[vim.fn.synIDattr(id, "name")]
    if local_def and not next(local_def) then
      return hl
    end
  end
  return api.nvim_get_hl(0, opts)
end

local function define_highlight(ns, name, attrs)
  if not vim.deep_equal(api.nvim_get_hl(ns, { name = name }), attrs) then
    api.nvim_set_hl(ns, name, attrs)
  end
end

local function diff_style(ctx, group, cursor)
  local key = cursor and group .. "Cursor" or group
  if ctx[key] then
    return ctx[key]
  end
  if not ctx.ns then
    ctx.ns = api.nvim_get_hl_ns({ winid = ctx.win })
    if ctx.ns < 0 then
      ctx.ns = api.nvim_get_hl_ns({})
    end
  end
  local hl = window_highlight(ctx, group)
  local bg, ctermbg = hl.bg, hl.ctermbg
  if cursor then
    local cul = window_highlight(ctx, "CursorLine")
    -- Neovim gives CursorLine priority when it defines a foreground.
    if cul.fg or cul.ctermfg then
      bg, ctermbg = cul.bg or bg, cul.ctermbg or ctermbg
    else
      bg, ctermbg = bg or cul.bg, ctermbg or cul.ctermbg
    end
  end
  local style = { context = ctx, background = "NumberColumn" .. key, bg = bg, ctermbg = ctermbg, signs = {} }
  define_highlight(ctx.ns, style.background, { bg = bg, ctermbg = ctermbg })
  ctx[key] = style
  return style
end

local function diff_sign_highlight(style, group)
  if not style.signs[group] then
    local attrs = window_highlight(style.context, group)
    attrs.bg, attrs.ctermbg = style.bg, style.ctermbg
    attrs.link, attrs.default, attrs.bg_indexed = nil, nil, nil
    local name = style.background .. group
    define_highlight(style.context.ns, name, attrs)
    style.signs[group] = name
  end
  return style.signs[group]
end

local function paint_diff_cells(native, style)
  local result = ""
  for i, hl in ipairs(native.highlights) do
    local next_hl = native.highlights[i + 1]
    local text = native.str:sub(hl.start + 1, next_hl and next_hl.start)
    if text ~= "" then
      local group = text:find("%S") and diff_sign_highlight(style, hl.group) or style.background
      result = result .. "%#" .. group .. "#" .. text:gsub("%%", "%%%%")
    end
  end
  return result
end

local function has_sign(buf, row)
  return #api.nvim_buf_get_extmarks(buf, -1, { row, 0 }, { row, -1 }, { type = "sign", overlap = true, limit = 1 }) > 0
end

local function diff_signs(style, win, buf, lnum, wrapped)
  if style.blank_signs and (wrapped or not has_sign(buf, lnum - 1)) then
    return style.blank_signs
  end

  -- Let %s resolve sign priority, highlighting and the window's current slot width.
  local native = api.nvim_eval_statusline("%s", { winid = win, use_statuscol_lnum = lnum, highlights = true })
  style.blank_signs = "%#" .. style.background .. "#" .. string.rep(" ", native.width)
  return wrapped and style.blank_signs or paint_diff_cells(native, style)
end

local function diff_statuscolumn(ctx, style, lnum, wrapped, number, git)
  local background = style.background
  local win, buf, signcolumn = ctx.win, ctx.buf, ctx.signcolumn
  -- With signcolumn=number, %l owns the sign and its highlight.
  if signcolumn == "number" and number ~= "" and not wrapped and has_sign(buf, lnum - 1) then
    local native =
      api.nvim_eval_statusline(ctx.number .. git, { winid = win, use_statuscol_lnum = lnum, highlights = true })
    return "%#" .. background .. "#%=" .. paint_diff_cells(native, style) .. "%*"
  end
  local show_signs = signcolumn ~= "no"
  local signs = show_signs and diff_signs(style, win, buf, lnum, wrapped) or ""
  if show_signs and wrapped then
    number = "%="
  end
  local base = "%#" .. background .. "#"
  if git ~= empty_git_column and git ~= "" then
    git = git
      :gsub("%%#(GitSigns[^#]+)#", function(group)
        return "%#" .. diff_sign_highlight(style, group) .. "#"
      end)
      :gsub("%%%*", function()
        return base
      end)
  end
  return signs .. base .. number .. git .. "%*"
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
  local win = api.nvim_get_current_win()
  local ctx = diff_gutter.context(win)
  if not ctx.signcolumn then
    local wo = vim.wo[win]
    ctx.signcolumn = wo.signcolumn
    ctx.number = (wo.number or wo.relativenumber) and number_column(wo.numberwidth) or ""
    ctx.foldenable = wo.foldenable
    ctx.terminal = vim.bo[ctx.buf].buftype == "terminal"
    if wo.cursorline then
      ctx.cursor = api.nvim_win_get_cursor(win)[1]
      ctx.cursor_background = M.has_cursorline_background(win)
      local opt = wo.cursorlineopt
      ctx.cursor_text = opt ~= "number" and not api.nvim_get_mode().mode:match("^[vV\22sS\19]")
      ctx.screenline = wo.wrap and opt:find("screenline", 1, true) ~= nil
    end
  end
  local show_signs = ctx.signcolumn ~= "no"
  local number = ctx.number
  if not show_signs and number == "" then
    return ""
  end

  local lnum, virt = vim.v.lnum, vim.v.virtnum
  local filler, corrected_line
  if ctx.diff then
    filler, corrected_line = diff_gutter.filler(win, lnum, virt)
    if filler then
      return filler
    end
  end
  if corrected_line then
    -- With topfill, Neovim can report the line before the viewport for its first real row.
    lnum = corrected_line
    if number ~= "" then
      number = "%=" .. vim.trim(api.nvim_eval_statusline("%l", { winid = win, use_statuscol_lnum = lnum }).str)
    end
  end
  local closed = virt == 0 and ctx.foldenable and foldclosed(lnum) == lnum
  local left = closed and folded_left or (show_signs and signs_left or "")
  local git = ""
  if not ctx.terminal then
    git = show_signs and virt == 0 and git_statuscolumn(ctx.buf, lnum) or empty_git_column
  end
  if ctx.diff and not closed and virt >= 0 and lnum > 0 then
    local group = diff_gutter.line_group(win, lnum)
    if group then
      local cursor = ctx.cursor == lnum and ctx.cursor_text
      if cursor and ctx.screenline then
        if not ctx.cursor_wrap then
          local row = lnum - 1
          ctx.cursor_wrap = api.nvim_win_text_height(win, {
            start_row = row,
            end_row = row,
            start_vcol = 0,
            end_vcol = vim.fn.virtcol("."),
          }).all - 1
        end
        cursor = virt == ctx.cursor_wrap
      end
      local style = diff_style(ctx, group, cursor)
      return diff_statuscolumn(ctx, style, lnum, virt > 0, number, git)
    end
  end

  local statuscolumn = left .. number .. git
  if closed then
    -- Folded rows intentionally keep their folded background when they are also the cursor line.
    statuscolumn = apply_background(statuscolumn, "FoldedColumn", "Folded", "FoldedColumn", folded_git_highlights)
  end

  if ctx.cursor == lnum and ctx.cursor_background then
    statuscolumn =
      apply_background(statuscolumn, "CursorLine", "CursorLine", "CursorLineColumn", cursorline_git_highlights)
  end

  return statuscolumn
end

return M
