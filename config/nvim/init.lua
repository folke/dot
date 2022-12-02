local util = require("util")

-- profile(function()

-- util.debug_pcall()
-- pcall(vim.cmd, "colorscheme tokyonight")

util.require("config.options")

vim.opt.runtimepath:append("~/projects/lazy.nvim/")

local start = vim.loop.hrtime()
-- load our colorscheme as soon as possible while installing
-- vim.api.nvim_create_autocmd("User", {
--   pattern = { "LazyPluginInstall", "LazyInstallPre" },
--   callback = function(event)
--     if event.match == "LazyInstallPre" or (event.data and event.data.plugin == "tokyonight") then
--       vim.cmd("silent! colorscheme tokyonight")
--     end
--   end,
-- })

require("lazy").setup("config.plugins", {
  defaults = { lazy = true },
  dev = { patterns = { "folke" } },
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
