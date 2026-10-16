return {
  "amadeus/gents.nvim",
  dependencies = {
    { "folke/snacks.nvim", version = false },
  },
  dev = true,
  version = false,
  lazy = false,
  opts = {
    picker = "snacks",
    layout = "botright vsplit",
    on_exit = "close",
    extend_gf = true,
    terminal_status = true,
    -- for testing default float layouts
    -- layout = "float",
    float = {
      width = 60,
      height = function()
        return vim.o.lines - 4
      end,
      row = 0,
      border = "rounded",
      anchor = "NE",
      col = function()
        return vim.o.columns
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("gents_notifications", { clear = true }),
      pattern = "GentsStatusChanged",
      callback = function(event)
        local data = event.data
        local current, previous = data.current, data.previous
        if data.visible or not current then
          return
        end

        local message
        local level = vim.log.levels.INFO
        if current.state == "blocked" then
          if
            previous
            and previous.state == "blocked"
            and previous.kind == current.kind
            and previous.msg == current.msg
          then
            return
          end
          message = ({
            permission = "Approval required",
            question = "Waiting for an answer",
            auth = "Authentication required",
          })[current.kind] or "Waiting for input"
          level = vim.log.levels.WARN
        elseif current.state == "error" then
          if previous and previous.state == "error" and previous.msg == current.msg then
            return
          end
          message = "Work failed"
          level = vim.log.levels.ERROR
        elseif data.record_id == "" then
          if
            current.state == "done" and (not previous or previous.state ~= "done")
            or current.state == "idle" and previous and previous.state == "working"
          then
            message = "Work finished"
          end
        end
        if not message then
          return
        end

        local name = data.title or data.label
        if data.record_id ~= "" then
          name = name .. " / " .. (current.title or data.record_id)
        end
        if current.msg and current.msg ~= "" then
          message = message .. "\n" .. current.msg
        end
        vim.notify(name .. ": " .. message, level, { title = data.tool })
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
      "<leader>ah",
      "<cmd>Gents hide --all<cr>",
      desc = "Gents: Hide all visible sessions",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>af",
      "<cmd>Gents focus<cr>",
      desc = "Gents: Toggle focus between last session or buffer",
      mode = { "n", "t", "i", "x" },
    },
    {
      -- Show the send prompt
      "<leader>sp",
      "<cmd>Gents send<cr>",
      mode = { "n", "x" },
      desc = "Gents: Send context picker",
    },
    {
      "<leader>sl",
      "<cmd>Gents send line<cr>",
      mode = { "n", "x" },
      desc = "Gents: Send line or selection",
    },
    {
      "<leader>sf",
      "<cmd>Gents send file<cr>",
      mode = "n",
      desc = "Gents: Send file reference",
    },
    {
      "<leader>sd",
      "<cmd>Gents send diagnostics<cr>",
      mode = "n",
      desc = "Gents: Send file diagnostics",
    },
    {
      "<leader>sv",
      "<cmd>Gents send selection<cr>",
      mode = "x",
      desc = "Gents: Copy and send selection",
    },
  },
}
