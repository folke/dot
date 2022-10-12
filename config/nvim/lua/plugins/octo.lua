local M = {
  cmd = "Octo",
}

function M.config()
  require("octo").setup()
end

return M
