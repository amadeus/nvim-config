return {
  "folke/sidekick.nvim",
  enabled = true,
  cmd = { "Sidekick" },
  opts = {
    nes = { enabled = false },
    cli = {
      tools = {
        amp = {
          cmd = { "amp" },
          format = function(text)
            local Text = require("sidekick.text")
            Text.transform(text, function(str)
              return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
            end, "SidekickLocFile")
            local ret = Text.to_string(text)
            -- transform line ranges to a format that amp understands
            ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-L(%d+):C%d+", "@%1#L%2-%3") -- @file :L5:C20-L6:C8 => @file#L5-6
            ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-C%d+", "@%1#L%2") -- @file :L5:C9-C29 => @file#L5
            ret = ret:gsub("@([^ ]+)%s*:L(%d+)%-L(%d+)", "@%1#L%2-%3") -- @file :L5-L13 => @file#L5-13
            ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+", "@%1#L%2") -- @file :L5:C9 => @file#L5
            ret = ret:gsub("@([^ ]+)%s*:L(%d+)", "@%1#L%2") -- @file :L5 => @file#L5
            return ret
          end,
        },
      },
      win = {
        -- Allow the terminal split to act like a normie vim buffer
        wo = { winfixwidth = false, winfixheight = false },
        split = { width = 0, height = 0 },
      },
    },
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").focus()
      end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>asl",
      function()
        require("sidekick.cli").send({ msg = "{line}" })
      end,
      mode = "n",
      desc = "Send Line",
    },
    {
      "<leader>asf",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      mode = "n",
      desc = "Send File",
    },
    {
      "<leader>ass",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = "x",
      desc = "Send Selection",
    },
    {
      "<leader>asv",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = "x",
      desc = "Send Visual Selection",
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Sidekick Close",
      mode = { "n", "t", "i", "x" },
    },
  },
}
