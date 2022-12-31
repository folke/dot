local M = {}

function M.packer(rebuild)
  if rebuild then
    local spec = require("plugins")
    local files = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/config/plugins/*.lua", false, true)
    table.insert(files, vim.fn.stdpath("config") .. "/lua/config/plugins/lsp/init.lua")
    for _, file in ipairs(files) do
      local modname = file:match("lua/(.*)%.lua"):gsub("/", ".")
      local plugin = loadfile(file)()
      for k, v in pairs(plugin) do
        if type(v) == "function" then
          if k == "init" or k == "run" or k == "config" then
            plugin[k == "init" and "setup" or k] = ('require("%s").%s()'):format(modname, k)
          else
            plugin[k] = nil
          end
        end
      end
      table.insert(spec, 1, plugin)
    end
    vim.cmd([[packadd packer.nvim]])
    require("packer").startup({
      spec,
      config = {
        profile = { enable = true },
        opt_default = true,
        transitive_opt = true,
        transitive_disable = true,
      },
    })
  end
  vim.defer_fn(function()
    vim.cmd("do VeryLazy")
  end, 1000)
end

return M
