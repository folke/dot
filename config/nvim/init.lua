local util = require("util")
local require = util.require

require("config.options")
require("config.lazy")
require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    util.version()
    require("config.commands")
    require("config.mappings")
  end,
})
