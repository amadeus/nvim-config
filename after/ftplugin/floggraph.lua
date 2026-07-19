for _, lhs in ipairs({ "y<C-G>", "y<C-T>", "y<C-X>" }) do
  vim.keymap.del({ "n", "v" }, lhs, { buffer = true })
end
