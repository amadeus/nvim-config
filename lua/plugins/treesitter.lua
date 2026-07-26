return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    -- TODO: Remove once nvim-treesitter-textobjects updates to use vim.treesitter.get_range()
    -- instead of reading metadata.range directly. See neovim PR #34383 for context.
    -- Preserve Neovim's normal offset metadata while also providing the concrete
    -- range currently expected by nvim-treesitter-textobjects.
    vim.treesitter.query.add_directive("offset!", function(match, _, _, pred, metadata)
      local capture_id = pred[2]
      local nodes = match[capture_id]
      if not nodes then
        return
      end

      local offset = {
        tonumber(pred[3]) or 0,
        tonumber(pred[4]) or 0,
        tonumber(pred[5]) or 0,
        tonumber(pred[6]) or 0,
      }
      metadata[capture_id] = metadata[capture_id] or {}
      metadata[capture_id].offset = offset

      -- A single concrete range cannot represent offsets for a quantified
      -- capture, so leave those to consumers of the standard offset metadata.
      local node = type(nodes) == "table" and #nodes == 1 and nodes[1] or nil
      if not node then
        return
      end

      local sr, sc, er, ec = node:range()
      local range = { sr + offset[1], sc + offset[2], er + offset[3], ec + offset[4] }
      if range[1] < range[3] or (range[1] == range[3] and range[2] <= range[4]) then
        metadata[capture_id].range = range
      end
    end, { force = true })

    -- Install commonly used parsers
    require("nvim-treesitter").install({
      "c",
      "css",
      "fish",
      "git_rebase",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- Enable treesitter highlighting for all filetypes with a parser
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        -- Only start if a parser exists for this filetype
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.treesitter.language.add(lang) then
          vim.treesitter.start(args.buf)
        end
      end,
    })

    -- Enable treesitter indentation (experimental), except for markdown
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if args.match == "markdown" then
          return
        end
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.treesitter.language.add(lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Folding
    vim.opt.foldlevel = 99
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
}
