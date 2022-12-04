local util = require("util")

-- profile(function()

-- util.debug_pcall()
-- pcall(vim.cmd, "colorscheme tokyonight")

util.require("config.options")

vim.opt.runtimepath:append("~/projects/lazy.nvim")

local start = vim.loop.hrtime()

require("lazy").setup("config.plugins", {
  defaults = { lazy = true },
  dev = { patterns = { "folke" } },
  install = { colorscheme = { "tokyonight", "habamax" } },
  performance = { cache = { enabled = true } },
  debug = true,
})

local delta = vim.loop.hrtime() - start

require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.notify("Lazy took " .. (delta / 1e6) .. "ms")
    util.require("config.commands")
    util.version()
    util.require("config.mappings")
  end,
})
