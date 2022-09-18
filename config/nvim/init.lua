local util = require("util")

-- util.debug_pcall()

require("options")

-- no need to load this immediately, since we have packer_compiled
vim.defer_fn(function()
  util.version()
  require("plugins")
end, 0)
