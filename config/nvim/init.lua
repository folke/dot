require("util")
require("options")

-- no need to load this immediately, since we have packer_compiled
vim.defer_fn(function()
  require("bootstrap")
  require("plugins")
end, 0)
