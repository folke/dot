local M = {
  "pwntester/octo.nvim",
  cmd = "Octo",
}

function M.config()
  require("octo").setup()
end

return M
