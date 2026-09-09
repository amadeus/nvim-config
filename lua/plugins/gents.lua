return {
  "amadeus/gents.nvim",
  dependencies = {
    { "folke/snacks.nvim", version = false },
  },
  dev = true,
  version = false,
  cmd = { "Gents" },
  opts = {
    picker = "snacks",
    layout = "botright vsplit",
    on_exit = "close",
    -- for testing default float layouts
    -- layout = "float",
    float = {
      width = 60,
      height = vim.o.lines - 4,
      row = 0,
      border = "rounded",
      anchor = "NE",
      col = vim.o.columns - 1,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("gents_notifications", { clear = true }),
      pattern = "GentsReady",
      callback = function(event)
        if not event.data.visible then
          local message = event.data.label .. " is waiting for input"
          vim.notify(message, vim.log.levels.INFO, {
            title = event.data.label,
          })
          if vim.api.nvim_ui_send then
            vim.api.nvim_ui_send("\027]9;" .. message:gsub("%c", "") .. "\027\\")
          end
        end
      end,
    })
    vim.keymap.set({ "n", "t", "i", "x" }, "<leader>as", "<Nop>")
    vim.keymap.set({ "n", "t", "i", "x" }, "<leader>ap", "<Nop>")
  end,
  keys = {
    {
      "<leader>ac",
      "<cmd>Gents actions<cr>",
      desc = "Gents: Pick action",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>ab",
      "<cmd>Gents pick<cr>",
      desc = "Gents: Pick session",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>an",
      "<cmd>Gents new<cr>",
      desc = "Gents: New session",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      "<cmd>Gents toggle<cr>",
      desc = "Gents: Toggle current session",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>sp",
      "<cmd>Gents send<cr>",
      mode = { "n", "x" },
      desc = "Gents: Send context picker",
    },
    {
      "<leader>af",
      "<cmd>Gents focus<cr>",
      desc = "Gents: Toggle focus between last session or buffer",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>sl",
      "<cmd>Gents send line<cr>",
      mode = "n",
      desc = "Gents: Send line or selection",
    },
    {
      "<leader>sl",
      "<cmd>Gents send line<cr>",
      mode = "x",
      desc = "Gents: Send line or selection",
    },
    {
      "<leader>sf",
      "<cmd>Gents send file<cr>",
      mode = "n",
      desc = "Gents: Send file reference",
    },
    {
      "<leader>sv",
      "<cmd>Gents send selection<cr>",
      mode = "x",
      desc = "Gents: Copy and send selection",
    },
  },
}
