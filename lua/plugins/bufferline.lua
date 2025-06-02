return {
  "akinsho/bufferline.nvim",
  version = false,
  opts = {
    options = {
      right_mouse_command = false,
      diagnostics = "nvim_lsp",
      color_icons = false,
      separator_style = "slope",
      show_close_icon = false,
      max_name_length = 30,
      truncate_names = false,
      show_buffer_close_icons = false,

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

      -- Some serious AI slope to always keep the parent folder around but
      -- abbreviate what's before it
      -- ./something/cool/(wow)/heh/file.tsx
      -- Becomes:
      -- ./s/c/(w/heh/file.tsx
      name_formatter = function(buf)
        if buf.bufnr and vim.bo[buf.bufnr].filetype == "codecompanion" then
          return "CodeCompanion Chat"
        end

        if buf.bufnr == vim.fn.winbufnr(0) and buf.path and buf.path ~= "" then
          return vim.fn.fnamemodify(buf.path, ":.")
        end

        if not buf.path or buf.path == "" then
          return buf.name
        end

        local file_path_abs = vim.fn.fnamemodify(buf.path, ":p")
        local file_name = vim.fs.basename(file_path_abs)

        if
          file_path_abs == file_name
          or vim.fs.dirname(file_path_abs) == "."
          or vim.fs.dirname(file_path_abs) == file_path_abs
        then
          return file_name
        end

        local cwd = vim.fs.normalize(vim.fn.getcwd())

        local path_relative_to_cwd = vim.fs.relpath(file_path_abs, cwd)

        if not path_relative_to_cwd or vim.fs.is_absolute(path_relative_to_cwd) then
          local cwd_with_sep = cwd
          if string.sub(cwd_with_sep, -1) ~= "/" and string.sub(cwd_with_sep, -1) ~= "\\" then
            cwd_with_sep = cwd_with_sep .. (string.find(cwd_with_sep, "\\") and "\\" or "/")
          end

          if string.sub(file_path_abs, 1, #cwd_with_sep) == cwd_with_sep then
            path_relative_to_cwd = string.sub(file_path_abs, #cwd_with_sep + 1)
          else
            local parent_dir_abs = vim.fs.dirname(file_path_abs)
            if parent_dir_abs == "/" or parent_dir_abs == "\\" then
              return file_name
            end
            local parent_basename = vim.fs.basename(parent_dir_abs)
            return (parent_basename ~= "" and parent_basename ~= ".") and (parent_basename .. "/" .. file_name)
              or file_name
          end
        end

        if string.sub(path_relative_to_cwd, 1, 2) == ".." then
          local parent_dir_abs = vim.fs.dirname(file_path_abs)
          if parent_dir_abs == "/" or parent_dir_abs == "\\" then
            return file_name
          end
          local parent_basename = vim.fs.basename(parent_dir_abs)
          return (parent_basename ~= "" and parent_basename ~= ".") and (parent_basename .. "/" .. file_name)
            or file_name
        end

        local dir_part_relative = vim.fs.dirname(path_relative_to_cwd)

        if dir_part_relative == "." then
          return file_name
        end

        local normalized_dir_part = string.gsub(dir_part_relative, "[\\/]+", "/")
        local dir_components = vim.split(normalized_dir_part, "/", { plain = true, trimempty = true })

        if #dir_components == 0 then
          return "./" .. path_relative_to_cwd
        end

        local display_segments = { "." }

        for i = 1, #dir_components - 1 do
          local comp = dir_components[i]
          local abbrev_comp = ""
          if comp and #comp > 0 then
            for k = 1, #comp do
              local char = string.sub(comp, k, k)
              abbrev_comp = abbrev_comp .. char
              if char:match("%a") then
                break
              end
            end
            if abbrev_comp == "" then
              abbrev_comp = comp
            end
          else
            abbrev_comp = "?"
          end
          table.insert(display_segments, abbrev_comp)
        end

        table.insert(display_segments, dir_components[#dir_components])
        table.insert(display_segments, file_name)

        local final_name = table.concat(display_segments, "/")
        return final_name
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
