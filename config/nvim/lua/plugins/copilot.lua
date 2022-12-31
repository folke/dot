local M = {
  "zbirenbaum/copilot.lua",
  enabled = false,
  event = "VeryLazy",
}

function M.config()
  require("copilot").setup({})
end

function M.test() end

return M
