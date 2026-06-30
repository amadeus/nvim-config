-- Longest common prefix of a list of strings, compared case-insensitively but
-- returned in the first string's casing. "" if none. Case-insensitive so that
-- pseudo-refs like ORIG_HEAD don't collapse the prefix of origin/* branches.
local function common_prefix(strings)
  local prefix = strings[1]
  for i = 2, #strings do
    local s = strings[i]
    local max = math.min(#prefix, #s)
    local j = 0
    while j < max and prefix:sub(j + 1, j + 1):lower() == s:sub(j + 1, j + 1):lower() do
      j = j + 1
    end
    prefix = prefix:sub(1, j)
    if prefix == "" then
      return ""
    end
  end
  return prefix
end

-- Gather the candidate insert-texts for the current command line, plus the
-- 0-indexed column where the argument being completed starts. Prefer blink's
-- list, which it populates as you type -- crucially this resolves custom
-- completions (e.g. fugitive's :Git) that Vim's getcompletion() can't. Fall
-- back to getcompletion() only when blink's list isn't populated yet.
local function cmdline_candidates(cmp)
  local items = cmp.get_items and cmp.get_items()
  if items and #items > 0 then
    local texts, arg_start = {}, nil
    for _, item in ipairs(items) do
      local text = (item.textEdit and item.textEdit.newText) or item.insertText or item.label
      if type(text) == "string" then
        texts[#texts + 1] = text
      end
      if arg_start == nil and item.textEdit and item.textEdit.insert then
        arg_start = item.textEdit.insert.start.character
      end
    end
    return texts, arg_start
  end

  local before = vim.fn.getcmdline():sub(1, vim.fn.getcmdpos() - 1)
  local ok, matches = pcall(vim.fn.getcompletion, before, "cmdline")
  return ok and matches or {}, nil
end

-- Shell-style cmdline tab completion: fill in the longest common prefix of all
-- *matching* candidates first; only once that prefix is exhausted do we fall
-- through to blink's menu. Returns true when it extended the line (stop the
-- chain), false to fall through to the next command.
local function cmdline_complete_prefix_impl(cmp)
  if vim.fn.getcmdtype() ~= ":" then
    return false
  end

  local texts, arg_start = cmdline_candidates(cmp)
  if #texts == 0 then
    return false
  end

  local line = vim.fn.getcmdline()
  local cursor = vim.fn.getcmdpos() - 1 -- 0-indexed byte cursor position

  -- Where the current argument starts. Prefer blink's computed column; fall
  -- back to the last whitespace-delimited word before the cursor.
  if arg_start == nil or arg_start > cursor then
    local head = line:sub(1, cursor)
    arg_start = cursor - #(head:match("%S*$") or "")
  end

  local typed = line:sub(arg_start + 1, cursor)

  -- blink's list is fuzzy-matched (and sometimes stale), so it contains items
  -- that don't actually start with what's typed -- keep only true prefix matches,
  -- otherwise the common prefix collapses. Match smartcase: typing an uppercase
  -- letter (e.g. ":AL") matches case-sensitively, so the built-in `all` command
  -- doesn't drag the prefix down to "al"; an all-lowercase query stays
  -- case-insensitive so file/branch completion keeps working.
  local ci = typed:match("%u") == nil
  local needle = ci and typed:lower() or typed
  local matching = {}
  for _, t in ipairs(texts) do
    local hay = ci and t:lower() or t
    if hay:sub(1, #needle) == needle then
      matching[#matching + 1] = t
    end
  end
  if #matching == 0 then
    return false
  end

  local prefix = common_prefix(matching)
  -- Nothing new to add -> let blink show its menu / cycle.
  if #prefix <= #typed then
    return false
  end

  vim.fn.setcmdline(line:sub(1, arg_start) .. prefix .. line:sub(cursor + 1), arg_start + #prefix + 1)
  -- setcmdline() emits no keypress, so blink's on_key listener never re-runs the
  -- sources and the menu keeps its stale list/highlights. cmp.show() no-ops while
  -- the menu is open, so force a fresh re-trigger (re-queries against the grown
  -- query, exactly as typing the characters manually would).
  vim.schedule(function()
    pcall(function()
      require("blink.cmp.completion.trigger").show({ force = true, trigger_kind = "manual" })
    end)
  end)
  return true
end

-- This runs inside blink's keymap loop, which does NOT wrap commands in pcall.
-- So we guard the whole thing: any error (e.g. blink changing its item shape or
-- API in an update) is swallowed and we return false, which simply falls through
-- to blink's default <Tab> handling instead of breaking the keymap.
local function cmdline_complete_prefix(cmp)
  local ok, extended = pcall(cmdline_complete_prefix_impl, cmp)
  return ok and extended or false
end

return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = { "folke/lazydev.nvim", "nvim-web-devicons" },
  opts = {
    keymap = {
      preset = "default",
      ["<C-n>"] = { "show", "select_next", "fallback" },
      ["<C-k>"] = { "fallback" },
      ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- Default list of enabled providers
    completion = {
      keyword = { range = "prefix" },
      list = {
        -- max_items = 1000,
        selection = {
          preselect = false,
        },
      },
      trigger = {
        prefetch_on_insert = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        -- show_on_blocked_trigger_characters = {},
        -- show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
      },
      -- A way to fix neovide cursor animations, however not currently using
      -- neovide rn...
      -- accept = {
      --   dot_repeat = false,
      -- },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon", "label", "label_description", gap = 1 },
            { "kind", "source_id", gap = 1 },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                -- Use file-specific icons for path completions
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                end
                return icon .. ctx.icon_gap
              end,
              -- Use color highlights from nvim-web-devicons for path completions
              -- Dim icon colors by blending with background using tokyonight's util
              highlight = (function()
                local dimmed_cache = {}
                local tn_util

                return function(ctx)
                  tn_util = tn_util or require("tokyonight.util")
                  local hl = ctx.kind_hl
                  if ctx.source_name == "Path" then
                    local _, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_hl then
                      hl = dev_hl
                    end
                  end

                  hl = hl or "Default"

                  -- Return cached dimmed highlight if it exists
                  if dimmed_cache[hl] then
                    return dimmed_cache[hl]
                  end

                  -- Create a dimmed version of the highlight
                  local hl_info = vim.api.nvim_get_hl(0, { name = hl, link = false })
                  if hl_info.fg then
                    local dimmed_hl = "BlinkCmpKindDim" .. hl
                    local fg_hex = string.format("#%06x", hl_info.fg)
                    local dimmed_fg = tn_util.blend_bg(fg_hex, 0.5)
                    vim.api.nvim_set_hl(0, dimmed_hl, { fg = dimmed_fg })
                    dimmed_cache[hl] = dimmed_hl
                    return dimmed_hl
                  end

                  dimmed_cache[hl] = hl
                  return hl
                end
              end)(),
            },
            label = {
              text = function(ctx)
                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                if highlights_info ~= nil then
                  -- Or you want to add more item to label
                  return highlights_info.label
                else
                  return ctx.label
                end
              end,
              highlight = function(ctx)
                local highlights = {}
                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                if highlights_info ~= nil then
                  highlights = highlights_info.highlights
                end
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                end
                -- Do something else
                return highlights
              end,
            },
          },
        },
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos
            return { pos[1] - 2, pos[2] }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height - 1, 0 }
        end,
      },
    },

    cmdline = {
      keymap = {
        preset = "none",
        ["<tab>"] = { cmdline_complete_prefix, "show_and_insert", "select_next" },
        ["<s-tab>"] = { "show_and_insert", "select_prev" },
        ["<c-space>"] = { "show", "fallback" },
        ["<c-n>"] = { "select_next", "fallback" },
        ["<c-p>"] = { "select_prev", "fallback" },
        ["<c-y>"] = { "select_and_accept" },
        ["<c-e>"] = { "cancel" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },

        -- Explicitly disable left/right arrow keys for completion
        ["<left>"] = { "fallback" },
        ["<right>"] = { "fallback" },
      },
      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
        menu = {
          auto_show = true,
        },
      },
    },

    sources = {
      default = {
        "lazydev",
        "lsp",
        "path",
        "buffer",
        -- "copilot",
        -- "avante",
        -- "parrot",
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        -- copilot = {
        --   name = "copilot",
        --   module = "blink-cmp-copilot",
        --   score_offset = 1,
        --   async = true,
        -- },
        -- avante = {
        --   module = "blink-cmp-avante",
        --   name = "Avante",
        --   opts = {},
        -- },
        -- parrot = {
        --   module = "parrot.completion.blink",
        --   name = "parrot",
        --   score_offset = 20,
        --   opts = {
        --     show_hidden_files = false,
        --     max_items = 50,
        --   },
        -- },
      },
      -- Appears to be broken at the moment, see: https://github.com/Saghen/blink.cmp/issues/836
      -- providers = {
      --   lsp = {
      --     override = {
      --       get_trigger_characters = function(self)
      --         local trigger_characters = self:get_trigger_characters()
      --         vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
      --         return trigger_characters
      --       end
      --     },
      --   },
      -- },
    },

    -- Experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        max_width = 1000,
        max_height = 3,
        show_documentation = false,
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
      use_frecency = true,
      use_proximity = true,
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
      -- NOTE: Remove this when I revert back to the fork
      -- prebuilt_binaries = { force_version = "v1.1.1" },
    },
  },
}
