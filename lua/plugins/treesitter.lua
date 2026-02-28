return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

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
