local M = {
  run = "deno task --quiet build:fast",
  module = "peek",
}

function M.config()
  -- default config:
  require("peek").setup({
    theme = "light", -- 'dark' or 'light'
  })
end

function M.init()
  vim.api.nvim_create_user_command("Peek", function()
    local peek = require("peek")
    if peek.is_open() then
      peek.close()
    else
      peek.open()
    end
  end, {})
end

return M
