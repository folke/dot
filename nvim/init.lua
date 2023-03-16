local debug = require("util.debug")

if vim.env.VIMCONFIG then
  return debug.switch(vim.env.VIMCONFIG)
end

-- require("util.profiler").start()

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    vim.schedule(function()
      -- require("lazy.core.cache").inspect()
    end)
  end,
})

vim.g.profile_loaders = true
require("config.lazy")({
  defaults = {
    lazy = true,
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
