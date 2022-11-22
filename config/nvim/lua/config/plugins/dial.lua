local M = {
  module = "dial",
  keys = { "<C-a>", "<C-x>" },
}

function M.config()
  local augend = require("dial.augend")
  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
      augend.constant.alias.bool,
      augend.semver.alias.semver,
    },
  })

  vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
  vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
end

return M
