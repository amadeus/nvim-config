local api = vim.api
local fn = vim.fn
local M = {}
local diff_add_id = fn.hlID("DiffAdd")
local views = {}
local watched = {}
local view, redraw
local window, topline, bottom, line_count
local line, last_text_line, virtual_rows, filler_rows, pattern

local function start_line(lnum)
  line = lnum
  virtual_rows = nil
  filler_rows = nil
end

local function clear_views()
  if next(views) then
    views = {}
  end
  view = nil
end

-- A hidden diff peer can change before Neovim delivers DiffUpdated on redraw.
local function watch_buffer(buf)
  if not watched[buf] then
    watched[buf] = api.nvim_buf_attach(buf, false, {
      on_lines = clear_views,
      on_reload = clear_views,
      on_detach = function()
        watched[buf] = nil
        clear_views()
      end,
    })
  end
end

local augroup = api.nvim_create_augroup("NvimConfigDiffGutter", { clear = true })
api.nvim_create_autocmd({ "DiffUpdated", "BufWinEnter", "BufWinLeave", "WinClosed" }, {
  group = augroup,
  callback = clear_views,
})
api.nvim_create_autocmd("OptionSet", {
  group = augroup,
  pattern = { "diff", "diffopt", "diffexpr", "diffanchors" },
  callback = clear_views,
})

-- The decoration provider identifies the buffer line about to be drawn, even
-- when Neovim gives its filler and text identical v:lnum and v:virtnum values.
api.nvim_set_decoration_provider(api.nvim_create_namespace("NvimConfigDiffGutter"), {
  on_win = function(_, win, buf, top, bot)
    redraw = { win = win, buf = buf, diff = vim.wo[win].diff }
    window = redraw.diff and win or nil
    if not window then
      return false
    end
    watch_buffer(buf)
    topline, bottom = top + 1, bot + 1
    -- External diffs can adjust hunks between DiffUpdated events.
    local internal = vim.o.diffexpr == "" and ("," .. vim.o.diffopt .. ","):find(",internal,", 1, true)
    view = internal and views[win] or nil
    local height = math.max(1, api.nvim_win_get_height(win))
    if not view or view.buf ~= buf or view.height ~= height then
      view = { buf = buf, height = height, rows = {} }
    end
    views[win] = internal and view or nil

    line_count = api.nvim_buf_line_count(buf)
    last_text_line = nil
    pattern = nil
    start_line(topline)
  end,
  ---@return integer skip_row
  on_range = function(_, _, _, row)
    start_line(row + 1)
    return row + 1
  end,
  on_end = function()
    window, redraw = nil, nil
  end,
})

local function fill_height()
  if line <= line_count then
    return api.nvim_win_text_height(window, { start_row = line - 1, end_row = line - 1, end_vcol = 0 }).fill
  end
  -- Omitting end_row includes virtual lines and diff filler below EOF.
  return api.nvim_win_text_height(window, { start_row = line_count - 1 }).fill
    - api.nvim_win_text_height(window, { start_row = line_count - 1, end_row = line_count - 1 }).fill
end

-- Native virtual text expands tabs at buffer tab stops, independently of 'list'.
local function wrapped_height(lines, width, tabstop, stops)
  if width <= 0 then
    return #lines
  end
  local rows = #lines
  for _, chunks in ipairs(lines) do
    local col, used = 0, 0
    for _, chunk in ipairs(chunks) do
      local text = chunk[1]
      if text ~= "" and not text:find("[^ -~]") then
        if used > width then -- A tab may occupy more than a whole row.
          rows, used = rows + 1, 0
        end
        rows = rows + math.floor((used + #text - 1) / width)
        used = (used + #text - 1) % width + 1
        col = col + #text
      else
        for _, char in ipairs(fn.split(text, [[\zs]])) do
          local cells
          if char == "\t" then
            local stop = 0
            for _, interval in ipairs(stops) do
              stop = stop + tonumber(interval)
              if stop > col then
                break
              end
            end
            local interval = tonumber(stops[#stops]) or tabstop
            cells = stop > col and stop - col or interval - (col - stop) % interval
          else
            cells = fn.strwidth(char)
          end
          if used + cells > width then
            rows, used = rows + 1, 0
          end
          col, used = col + cells, used + cells
        end
      end
    end
  end
  return rows
end

---@class nvim_config.VirtualLineDetails : vim.api.keyset.extmark_details
---@field virt_lines [string, string|string[]|nil][][]
---@field virt_lines_overflow? "trunc"|"scroll"|"wrap"|"auto"

-- Only ordinary virtual rows invoke the statuscolumn. Full-width annotations
-- can be arbitrarily long and never need to be measured here.
local function virtual_gutter_rows(diff_rows, total_virtual)
  local first = { math.max(0, line - 2), 0 }
  local last = { math.min(line, line_count) - 1, -1 }
  local rows, wrapped = 0, {}
  ---@type integer?
  local fixed_full_width = 0
  for _, mark in ipairs(api.nvim_buf_get_extmarks(redraw.buf, -1, first, last, { type = "virt_lines", details = true })) do
    local owner, details = mark[2] + 1, mark[4]
    ---@cast details nvim_config.VirtualLineDetails
    if not details.invalid and owner + (details.virt_lines_above and 0 or 1) == line and fn.foldclosed(owner) == -1 then
      local wins = api.nvim__ns_get(details.ns_id).wins
      if not wins or #wins == 0 or vim.list_contains(wins, window) then
        local wraps = details.virt_lines_overflow == "wrap"
          or (details.virt_lines_overflow == "auto" and vim.wo[window].wrap)
        if details.virt_lines_leftcol then
          if wraps then
            fixed_full_width = nil
          elseif fixed_full_width then
            fixed_full_width = fixed_full_width + #details.virt_lines
          end
        elseif wraps then
          wrapped[#wrapped + 1] = details.virt_lines
        else
          rows = rows + #details.virt_lines
        end
      end
    end
  end
  if #wrapped > 0 then
    if fixed_full_width then
      return (total_virtual or (fill_height() - diff_rows)) - fixed_full_width
    end
    -- Both kinds wrap here. Cache the ordinary annotations by content, since
    -- changing an extmark does not increment the buffer changedtick.
    local layout = {
      width = api.nvim_win_get_width(window) - fn.getwininfo(window)[1].textoff,
      tabstop = vim.bo[redraw.buf].tabstop,
      stops = vim.opt_local.vartabstop:get(),
      ambiwidth = vim.o.ambiwidth,
      cellwidths = fn.getcellwidths(),
      lines = wrapped,
    }
    local previous = view and view.wrap
    if previous and vim.deep_equal(previous.layout, layout) then
      return rows + previous.height
    end
    local height = 0
    local stops = layout.stops[1] == "0" and {} or layout.stops
    for _, lines in ipairs(wrapped) do
      height = height + wrapped_height(lines, layout.width, layout.tabstop, stops)
    end
    if view then
      view.wrap = { layout = layout, height = height }
    end
    rows = rows + height
  end
  return rows
end

function M.context(win)
  if redraw and redraw.win == win then
    return redraw
  end
  return { win = win, buf = api.nvim_win_get_buf(win), diff = vim.wo[win].diff }
end

function M.filler(win, lnum, virt)
  if win ~= window then
    return
  end

  if virt == 0 and lnum == vim.v.relnum then
    -- For relative numbers alone Neovim measures the window height instead.
    if lnum == line_count or (vim.wo.relativenumber and not vim.wo.number and lnum == fn.getwininfo(win)[1].height) then
      return
    end
  end
  if virt > 0 and lnum == last_text_line then
    return -- Wrapped text.
  end
  if virt == 0 and lnum >= line then
    last_text_line = lnum
    start_line(lnum + 1)
    return
  end
  -- A gutter-only redraw can skip the decoration callback for the text.
  if line < lnum or line > lnum + 1 then
    start_line(lnum + 1)
  end
  if not filler_rows then
    filler_rows = fn.diff_filler(line)
    virtual_rows = 0
    if filler_rows > 0 then
      local diff_rows, total_virtual = filler_rows, nil
      if line == topline then
        local visible = fn.winsaveview().topfill
        total_virtual = fill_height() - diff_rows
        filler_rows = math.max(0, visible - total_virtual)
        virtual_rows = math.min(visible, total_virtual)
      end
      if filler_rows > 0 then
        virtual_rows = virtual_gutter_rows(diff_rows, total_virtual)
      end
    end
  end
  if virtual_rows > 0 then
    virtual_rows = virtual_rows - 1
  elseif filler_rows > 0 then
    filler_rows = filler_rows - 1
    if not pattern then
      local char = vim.opt.fillchars:get().diff
      char = type(char) == "string" and char or "-"
      pattern = "%#DiffDelete#" .. char:rep(fn.getwininfo(win)[1].textoff):gsub("%%", "%%%%") .. "%*"
    end
    return pattern
  elseif virt == 0 then
    last_text_line = line
    start_line(line + 1)
    if last_text_line == topline and lnum == topline - 1 then
      return nil, topline
    end
  end
end

local function line_group(lnum)
  local id = fn.diff_hlID(lnum, 1)
  if id ~= 0 then
    -- DiffText and DiffTextAdd describe individual spans on a DiffChange row.
    return id == diff_add_id and "DiffAdd" or "DiffChange"
  end
end

function M.line_group(win, lnum)
  if win ~= window then
    -- Explicit statuscolumn evaluations also run outside a redraw.
    return line_group(lnum)
  end

  local group
  if view and lnum >= topline and lnum <= bottom then
    -- Keep at most a screenful per window while reusing rows during scrolling.
    local slot = lnum % view.height
    local rows = view.rows
    local row = rows[slot]
    if not row or row.lnum ~= lnum then
      row = { lnum = lnum, group = line_group(lnum) }
      rows[slot] = row
    end
    group = row.group
  else
    -- Width probes can ask about an offscreen line before Neovim aligns its hunk.
    group = line_group(lnum)
  end
  return group
end

return M
