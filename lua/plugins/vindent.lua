return {
  "jessekelighine/vindent.nvim",
  version = false,
  config = function()
    local keymap_set = function(lhs, rhs)
      vim.keymap.set({ "x", "o" }, lhs, rhs)
    end
    keymap_set("ii", "<Plug>(VindentObject_XX_ii)")
    keymap_set("ai", "<Plug>(VindentObject_XX_ai)")
    keymap_set("aI", "<Plug>(VindentObject_XX_aI)")
  end,
}
