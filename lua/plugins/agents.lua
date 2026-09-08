return {
  "amadeus/agents.nvim",
  dependencies = {
    { "folke/snacks.nvim", version = false },
  },
  dev = true,
  version = false,
  cmd = { "Agents" },
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
      group = vim.api.nvim_create_augroup("agents_notifications", { clear = true }),
      pattern = "AgentsReady",
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
      "<cmd>Agents actions<cr>",
      desc = "Agents: Pick action",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>ab",
      "<cmd>Agents pick<cr>",
      desc = "Agents: Pick session",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>an",
      "<cmd>Agents new<cr>",
      desc = "Agents: New session",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      "<cmd>Agents toggle<cr>",
      desc = "Agents: Toggle current session",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>sp",
      "<cmd>Agents send<cr>",
      mode = { "n", "x" },
      desc = "Agents: Send context picker",
    },
    {
      "<leader>af",
      "<cmd>Agents focus<cr>",
      desc = "Agents: Toggle focus between last session or buffer",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>sl",
      "<cmd>Agents send line<cr>",
      mode = "n",
      desc = "Agents: Send line or selection",
    },
    {
      "<leader>sl",
      "<cmd>Agents send line<cr>",
      mode = "x",
      desc = "Agents: Send line or selection",
    },
    {
      "<leader>sf",
      "<cmd>Agents send file<cr>",
      mode = "n",
      desc = "Agents: Send file reference",
    },
    {
      "<leader>sv",
      "<cmd>Agents send selection<cr>",
      mode = "x",
      desc = "Agents: Copy and send selection",
    },
  },
}
