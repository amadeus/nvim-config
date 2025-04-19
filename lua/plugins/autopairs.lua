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
}
