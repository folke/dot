-- vim.loader = false
if vim.loader then
  vim.loader.enable()
  vim.schedule(function()
    vim.notify("nvim loader is enabled")
  end)
end

_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd

-- require("util.profiler").start()

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    vim.schedule(function()
      -- require("lazy.core.cache").inspect()
    end)
  end,
})

-- vim.g.profile_loaders = true
require("config.lazy")({
  debug = false,
  defaults = {
    lazy = true,
    -- cond = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
})

-- require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.env")
    require("util").version()
  end,
})
