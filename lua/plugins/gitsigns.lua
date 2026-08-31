return {
  "lewis6991/gitsigns.nvim",
  version = false,
  opts = {
    -- NOTE(amadeus): Don't really like the default `~` for
    -- changedelete...
    signs = {
      delete = { text = "╂" },
      topdelete = { text = "╂" },
      changedelete = { text = "╋" },
    },
    signs_staged = {
      delete = { text = "╂" },
      topdelete = { text = "╂" },
      changedelete = { text = "╋" },
    },
    update_debounce = 16,
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      -- Navigate hunks
      vim.keymap.set("n", "<D-j>", function()
        -- Gitsigns fills the omitted NavOpts fields internally despite marking them as required.
        ---@diagnostic disable-next-line: missing-fields
        gitsigns.nav_hunk("next", { wrap = false, foldopen = false })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<D-J>", function()
        ---@diagnostic disable-next-line: missing-fields
        gitsigns.nav_hunk("next", { wrap = false, foldopen = false, target = "all" })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<D-k>", function()
        ---@diagnostic disable-next-line: missing-fields
        gitsigns.nav_hunk("prev", { wrap = false, foldopen = false })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<D-K>", function()
        ---@diagnostic disable-next-line: missing-fields
        gitsigns.nav_hunk("prev", { wrap = false, foldopen = false, target = "all" })
      end, { buffer = bufnr, silent = true })

      -- Stage and reset hunks
      vim.keymap.set("n", "<leader>sh", function()
        gitsigns.stage_hunk()
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("v", "<leader>sh", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<leader>rh", function()
        gitsigns.reset_hunk()
      end, { buffer = bufnr, silent = true })
      -- By adding this noop mapping, we make sure to never fall back into the
      -- default `s` mapping if there's too much of a delay, which replaces the
      -- current character or selection and enters insert mode
      vim.keymap.set({ "n", "v" }, "<leader>s", "<Nop>", { buffer = bufnr, silent = true })
    end,

    preview_config = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)

    local function find_upvalue(fn, target)
      for index = 1, math.huge do
        local name, value = debug.getupvalue(fn, index)
        if not name then
          return
        elseif name == target then
          return value, index
        end
      end
    end

    -- Gitsigns does not expose its blame graph glyphs as configuration.
    local blame = require("gitsigns.actions.blame").blame
    local render = find_upvalue(blame, "render")
    local chars = render and find_upvalue(render, "chars")
    if chars then
      chars.first = "╭"
      chars.last = "╰"
      chars.single = "•"
    end

    -- The separator shown between adjacent single-line commits is otherwise hard-coded to Comment.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("GitsignsBlameFiller", { clear = true }),
      pattern = "gitsigns-blame",
      callback = function(event)
        vim.schedule(function()
          local namespace = vim.api.nvim_get_namespaces().gitsigns_blame_win_hl

          local function update_filler()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local bufnr = vim.api.nvim_win_get_buf(win)
              if bufnr ~= event.buf then
                local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, namespace, 0, -1, { details = true })
                for _, extmark in ipairs(extmarks) do
                  local id, row, col, details = unpack(extmark)
                  if details.virt_lines then
                    details.virt_lines[1][1][2] = "GitSignsBlameFiller"
                    vim.api.nvim_buf_set_extmark(bufnr, namespace, row, col, {
                      id = id,
                      virt_lines = details.virt_lines,
                      virt_lines_leftcol = true,
                    })
                  end
                end
              end
            end
          end

          vim.api.nvim_create_autocmd("CursorMoved", {
            group = "GitsignsBlameFiller",
            buffer = event.buf,
            callback = update_filler,
          })
          update_filler()
        end)
      end,
    })
  end,
}
