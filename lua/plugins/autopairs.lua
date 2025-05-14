return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  version = false,
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
      typescript = { "template_string" },
      tsx = { "template_string" },
    },
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    -- Add rule for ``` in 'codecompanion' filetype
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    npairs.add_rule(Rule("```", "```", "codecompanion"):with_cr(cond.after_text("```")))
  end,
}
