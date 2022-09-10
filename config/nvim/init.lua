local function p(fn, ...)
  local args = { ... }
  return xpcall(fn and function()
    return fn(unpack(args))
  end, function(err)
    if err:find("DevIcon") or err:find("mason") or err:find("Invalid highlight") then
      return err
    end
    vim.api.nvim_echo({ { err, "ErrorMsg" }, { debug.traceback("", 3), "Normal" } }, true, {})
    return err
  end)
end

-- _G.pcall = p
local util = require("util")
require("options")

-- no need to load this immediately, since we have packer_compiled
vim.defer_fn(function()
  util.version()
  require("plugins")
end, 0)
