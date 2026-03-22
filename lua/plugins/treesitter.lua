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
    -- Override #offset! to also set metadata.range (like #trim! does).
    -- Neovim's built-in #offset! only sets metadata.offset, but nvim-treesitter-textobjects
    -- reads metadata.range, so offsets are silently ignored for text objects.
    vim.treesitter.query.add_directive("offset!", function(match, _, _, pred, metadata)
      local capture_id = pred[2]
      local node = match[capture_id]
      if not node then
        return
      end
      if type(node) == "table" then
        node = node[1]
      end
      if not node then
        return
      end
      local sr, sc, er, ec = node:range()
      metadata[capture_id] = metadata[capture_id] or {}
      metadata[capture_id].range = {
        sr + (tonumber(pred[3]) or 0),
        sc + (tonumber(pred[4]) or 0),
        er + (tonumber(pred[5]) or 0),
        ec + (tonumber(pred[6]) or 0),
      }
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
