return {
  "junegunn/fzf.vim",
  dependencies = { "junegunn/fzf" },
  init = function()
    -- NOTE: passing a dict to window enables the popup window functionality
    vim.g.fzf_layout = {
      window = {
        width = 1,
        height = 0.2,
        border = "none",
        yoffset = 1.0,
      },
    }

    -- Set fzf_colors only if not using Neovim
    if not vim.fn.has("nvim") == 1 then
      vim.g.fzf_colors = {
        fg = { "fg", "fzfRegion" },
        bg = { "bg", "fzfRegion" },
        hl = { "fg", "IncSearch" },
        ["fg+"] = { "fg", "WildMenu" },
        ["bg+"] = { "bg", "WildMenu" },
        ["hl+"] = { "fg", "Statement" },
        info = { "fg", "PreProc" },
        border = { "fg", "LineNr" },
        prompt = { "fg", "IncSearch" },
        pointer = { "bg", "WildMenu" },
        marker = { "fg", "Statement" },
        spinner = { "fg", "Label" },
        header = { "fg", "Comment" },
        gutter = { "bg", "fzfRegion" },
      }
    end

    -- Disable the preview window
    vim.g.fzf_preview_window = {}
  end,
  config = function()
    -- Custom FZF buffer deletion command
    local function list_buffers()
      local list = vim.fn.split(vim.fn.execute("ls"), "\n")
      return list
    end

    local function delete_buffers(lines)
      local bufnrs = vim.tbl_map(function(line)
        return vim.split(line, " ")[1]
      end, lines)
      vim.cmd("bwipeout " .. table.concat(bufnrs, " "))
    end

    vim.api.nvim_create_user_command("BD", function()
      vim.fn["fzf#run"](vim.fn["fzf#wrap"]({
        source = list_buffers(),
        ["sink*"] = delete_buffers,
        options = "--multi --reverse --bind ctrl-a:select-all+accept",
      }))
    end, {})

    -- Keymaps
    vim.keymap.set("n", "<leader>t", ":GFiles<CR>")
    vim.keymap.set("n", "<leader>b", ":Buffers<CR>")
    vim.keymap.set("n", "<leader>/", ":Rg<CR>")
  end,
}
