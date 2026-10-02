-- Keep puts on internal registers; the terminal handles system pastes.
-- Should be removed when Rex supports OSC 52 reads
vim.opt.clipboard = ""
local termfeatures = vim.g.termfeatures or {}
termfeatures.osc52 = false
vim.g.termfeatures = termfeatures

local copy = require("vim.ui.clipboard.osc52").copy("+")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("clipboard-yank", { clear = true }),
  desc = "Copy yanks to the host clipboard with OSC 52",
  callback = function()
    if vim.v.event.operator ~= "y" then
      return
    end

    local lines = vim.deepcopy(vim.v.event.regcontents)
    if vim.v.event.regtype == "V" then
      table.insert(lines, "")
    end
    copy(lines)
  end,
})
