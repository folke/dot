local M = {
  enabled = false,
  event = "User VeryLazy",
}

function M.config()
  require("copilot").setup({})
end

function M.test() end

return M
