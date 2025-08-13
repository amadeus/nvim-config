return {
  "jessekelighine/vindent.nvim",
  version = false,
  opts = {
    begin = true,
    noisy = false,
    infer = false,
  },
  config = function(_, opts)
    local vindent = require("vindent")
    local block_opts = {
      strict = { skip_empty_lines = false, skip_more_indented_lines = false },
      contiguous = { skip_empty_lines = false, skip_more_indented_lines = true },
      loose = { skip_empty_lines = true, skip_more_indented_lines = true },
    }
    vindent.map.Object("iI", "ii", block_opts.loose)
    vindent.map.Object("ii", "ii", block_opts.contiguous)
    vindent.map.Object("ai", "ai", block_opts.loose)
    vindent.map.Object("aI", "aI", block_opts.loose)
    vindent.map.Motion({ prev = "[[", next = "]]" }, "less")
    vindent.setup(opts)
  end,
}
