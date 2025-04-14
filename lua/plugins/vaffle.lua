-- Helper function to map keys with default values
local function map_default(mode, lhs, vaffle_command, sp_args)
  local cmd = string.format("%smap %s %s <Plug>(vaffle-%s)", mode, sp_args, lhs, vaffle_command)
  vim.cmd(cmd)
end

-- This method is simply an AI slop converted version of the built in one in
-- Vaffle.  Basically I want most of the default mappings but with only a few
-- differences, so opted for a more simple copy/pasta and tweak
local function setup_custom_mappings()
  -- Toggle
  map_default("n", "*", "toggle-current", "<buffer> <silent>")
  map_default("n", "<Tab>", "toggle-current", "<buffer> <silent>")
  map_default("n", ".", "toggle-hidden", "<buffer> <silent>")
  map_default("v", "*", "toggle-current", "<buffer> <silent>")
  -- Operations for selected items
  map_default("n", "d", "delete-selected", "<buffer> <nowait> <silent>")
  map_default("n", "x", "fill-cmdline", "<buffer> <silent>")
  map_default("n", "m", "move-selected", "<buffer> <silent>")
  map_default("n", "<CR>", "open-selected", "<buffer> <silent>")
  map_default("n", "s", "open-selected-vsplit", "<buffer> <silent>")
  map_default("n", "r", "rename-selected", "<buffer> <silent>")
  -- Operations for a item on cursor
  map_default("n", "l", "open-current", "<buffer> <silent>")
  map_default("n", "t", "open-current-tab", "<buffer> <nowait> <silent>")
  -- Misc
  map_default("n", "o", "mkdir", "<buffer> <silent>")
  map_default("n", "i", "new-file", "<buffer> <silent>")
  map_default("n", "~", "open-home", "<buffer> <silent>")
  map_default("n", "h", "open-parent", "<buffer> <silent>")
  map_default("n", "q", "quit", "<buffer> <silent>")
  map_default("n", "R", "refresh", "<buffer> <silent>")
end

return {
  "cocopon/vaffle.vim",
  version = false,
  init = function()
    vim.g.vaffle_use_default_mappings = 0
  end,
  config = function()
    vim.keymap.set("n", "<leader>vv", ":Vaffle<CR>")
    vim.keymap.set("n", "<leader>vf", ":Vaffle %<CR>")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("vaffletab", { clear = true }),
      pattern = "vaffle",
      callback = function()
        vim.opt_local.number = false
        setup_custom_mappings()
      end,
    })
  end,
}
