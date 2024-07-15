if vim.env.VSCODE then
  vim.g.vscode = true
end

if vim.loader then
  vim.loader.enable()
end

-- local cache_root = vim.fn.stdpath("cache") .. "/fast"
-- local _, cache = pcall(function()
--   return loadfile(cache_root .. "/cache.lua")()
-- end)
-- cache = cache or {}
-- table.insert(package.loaders, 2, function(mod)
--   local file = cache[mod]
--   if file then
--     local chunk, err = loadfile(file)
--     return chunk, err
--   else
--     -- vim.schedule(function()
--     --   dd(mod)
--     -- end)
--   end
-- end)
--
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function(ev)
--     vim.fn.mkdir(cache_root, "p")
--     cache = {}
--     for modname in pairs(package.loaded) do
--       local info = vim.loader.find(modname)[1]
--       cache[modname] = info and info.modpath or nil
--     end
--     require("lazy.util").write_file(cache_root .. "/cache.lua", "return " .. vim.inspect(cache))
--   end,
-- })

_G.dd = function(...)
  require("util.debug").dump(...)
end
_G.bt = function(...)
  require("util.debug").bt(...)
end
vim.print = _G.dd

-- require("util.profiler").startup()

pcall(require, "config.env")

require("config.lazy")({
  -- debug = false,
  profiling = {
    loader = false,
    require = true,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
