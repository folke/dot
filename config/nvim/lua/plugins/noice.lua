local M = {
  module = "noice",
  event = "VimEnter",
}

function M.config()
  require("noice").setup({ debug = true })
end

return M
