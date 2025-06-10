return {
  "akinsho/bufferline.nvim",
  enabled = false,
  version = false,
  opts = {
    options = {
      right_mouse_command = false,
      diagnostics = "nvim_lsp",
      color_icons = false,
      separator_style = "thick",
      show_close_icon = false,
      max_name_length = 30,
      truncate_names = false,
      show_buffer_close_icons = false,
      show_duplicate_prefix = true,

      ---@diagnostic disable-next-line: unused-local
      custom_filter = function(buf, buf_nums)
        -- Hide fugitive and related buffers
        local buf_name = vim.fn.bufname(buf)
        local ft = vim.bo[buf].filetype
        if buf_name and string.match(buf_name, "^fugitive://") then
          return false
        end
        if ft == "help" or ft == "fugitive" or ft == "gitcommit" then
          return false
        end

        -- Hide all buffers that are not in the active tab...
        local current_tab_nr = vim.fn.tabpagenr()
        local buffers_in_current_tab = vim.fn.tabpagebuflist(current_tab_nr)
        for _, b_in_tab in ipairs(buffers_in_current_tab) do
          if b_in_tab == buf then
            return true
          end
        end
        return false
      end,

      name_formatter = function(buf)
        if buf.path then
          local path_component = string.match(buf.path, "^vaffle://%d+[/]+(.*)")
          if path_component then
            local abs_path = "/" .. path_component
            local cwd = vim.fn.getcwd()
            local rel_to_cwd_path = vim.fn.fnamemodify(abs_path, ":.")
            if abs_path == cwd then
              return vim.fs.basename(abs_path)
            elseif string.sub(rel_to_cwd_path, 1, 3) == "../" then
              return abs_path
            else
              return "./" .. rel_to_cwd_path
            end
          end
        end
        if buf.bufnr == vim.fn.winbufnr(0) and buf.path and buf.path ~= "" then
          return vim.fn.fnamemodify(buf.path, ":.")
        end
        if buf.name and buf.name ~= "" then
          return buf.name
        elseif buf.path and buf.path ~= "" then
          return vim.fs.basename(buf.path)
        else
          return "No Name"
        end
      end,
    },
  },
  init = function()
    vim.opt.laststatus = 3
  end,
  config = function(_, opts)
    local bufferline = require("bufferline")
    opts.options.style_preset = bufferline.style_preset.no_italic
    bufferline.setup(opts)
  end,
}
