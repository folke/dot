local util = require("util")

-- util.debug_pcall()

util.require("config.options")

vim.schedule(function()
  util.packer_defered()
  util.version()
  util.require("config.commands")
  util.require("config.mappings")
  util.require("config.plugins")
end)
