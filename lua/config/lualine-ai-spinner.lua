local spinner_symbols = { "𜶫", "𜷚", "𜷣", "𜷥", "𜷤", "𜷠", "𜷊", "𜵰" }

local Spinner = require("lualine.component"):extend()

Spinner.processing = false
Spinner.spinner_index = 1

function Spinner:init(options)
  Spinner.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
    end,
  })
end

function Spinner:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % #spinner_symbols) + 1
    return "🧠" .. spinner_symbols[self.spinner_index]
  else
    return nil
  end
end

return Spinner
