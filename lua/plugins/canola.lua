local detail = false
local trash_source
return {
  {
    "https://github.com/barrettruth/canola.nvim/",
    branch = "canola",
    version = false,

    lazy = false,
    init = function()
      vim.g.canola = {
        columns = { "git_status", "icon" },
        buf = {
          buflisted = false,
          bufhidden = "hide",
        },
        win = {
          signcolumn = "no",
        },
        lsp = {
          enabled = true,
        },
        keymaps = {
          ["g?"] = { callback = "actions.show_help", mode = "n" },

          ["<CR>"] = "actions.select",
          ["<C-s>"] = { callback = "actions.select", opts = { vertical = true } },
          ["<C-v>"] = { callback = "actions.select", opts = { vertical = true } },
          ["<C-x>"] = { callback = "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { callback = "actions.select", opts = { tab = true } },

          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = { callback = "actions.close", mode = "n" },
          ["<C-r>"] = "actions.refresh",

          ["-"] = { callback = "actions.parent", mode = "n" },
          ["<bs>"] = { callback = "actions.parent", mode = "n" },

          ["_"] = { callback = "actions.open_cwd", mode = "n" },
          ["`"] = { callback = "actions.cd", mode = "n" },
          ["~"] = { callback = "actions.cd", mode = "n" },

          ["gs"] = { callback = "actions.change_sort", mode = "n" },
          ["g."] = { callback = "actions.toggle_hidden", mode = "n" },
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["g~"] = false,
          ["gx"] = false,
          ["gy"] = false,
          ["q"] = false,
        },
      }
      vim.g.canola_git = {
        show = { untracked = true, ignored = true },
        format = "symbol",
      }
      vim.g.canola_ssh = {}
      vim.g.canola_s3 = {}
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("CanolaKeymaps", { clear = true }),
        pattern = "canola",
        callback = function(args)
          vim.keymap.set("n", "gd", function()
            detail = not detail
            require("canola").set_columns(
              detail and { "git_status", "icon", "permissions", "size", "mtime" } or { "git_status", "icon" }
            )
          end, { buffer = args.buf, desc = "Toggle file detail view" })
          vim.keymap.set("n", "g\\", function()
            local canola = require("canola")
            local url = canola.get_current_url()
            if url and vim.startswith(url, "canola-trash://") then
              canola.open(trash_source or vim.fn.getcwd())
            elseif url and vim.startswith(url, "canola://") then
              trash_source = url
              canola.open(url:gsub("^canola://", "canola-trash://"))
            else
              vim.notify("No trash found for buffer", vim.log.levels.WARN)
            end
          end, { buffer = args.buf, desc = "Toggle trash" })
        end,
      })
    end,
    config = function()
      -- Register browsing without redirecting file deletions to the trash.
      require("canola").register_adapter("canola-trash://", "trash")
      local function canola_alias(args)
        vim.cmd("Canola " .. args.args)
      end
      vim.api.nvim_create_user_command("O", canola_alias, { nargs = "*", desc = "Canola shortcut" })
      vim.api.nvim_create_user_command("F", canola_alias, { nargs = "*", desc = "Canola shortcut" })
    end,
  },
  {
    "https://github.com/barrettruth/canola-collection",
    version = false,
    lazy = false,
    dependencies = { "https://github.com/barrettruth/canola.nvim/" },
  },
}
