local win

local text = {
  " `gra` → code actions",
  " `gri` → implementations",
  " `grn` → rename",
  " `grr` → references",
  " `grt` → type definition",
  " `grx` → run codelens",
  " `gO` → document symbols",
  " `Ctrl-S` in Insert mode → signature help",
}

vim.api.nvim_create_user_command("Hotkeys", function()
  if win and win:valid() then
    win:focus()
    return
  end

  win = require("snacks").win({
    title = " Builtin LSP Keymaps ",
    border = "single",
    width = 50,
    height = #text,
    enter = true,
    ft = "markdown",
    bo = { modifiable = false },
    text = text,
    footer = " esc to close ",
    wo = {
      wrap = true,
      conceallevel = 2,
      concealcursor = "nc",
    },
    keys = {
      q = "close",
      ["<Esc>"] = "close",
    },
  })
end, { desc = "Show the hotkey reference" })

vim.api.nvim_create_user_command("H", "Hotkeys", { desc = "Show the hotkey reference" })
