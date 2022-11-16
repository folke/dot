local util = require("util")

-- util.debug_pcall()

require("util.dashboard").setup()

util.require("config.options")

vim.defer_fn(function()
  util.require("config.commands")
  util.version()
  util.require("config.mappings")
  util.packer_defered()
  util.require("config.plugins")
end, 100)
