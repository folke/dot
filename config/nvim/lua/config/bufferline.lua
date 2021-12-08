local signs = require("config.lsp.diagnostics").signs

signs = {
  error = signs.Error,
  warning = signs.Warn,
  info = signs.Info,
  hint = signs.Hint,
}

local severities = {
  "error",
  "warning",
  -- "info",
  -- "hint",
}

require("bufferline").setup({
  options = {
    show_close_icon = true,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    separator_style = "slant",
    diagnostics_indicator = function(_, _, diag)
      local s = {}
      for _, severity in ipairs(severities) do
        if diag[severity] then
          table.insert(s, signs[severity] .. diag[severity])
        end
      end
      return table.concat(s, " ")
    end,
  },
})
-- Ask for a user name until API returns a valid user
-- Hamburgefonstiv
