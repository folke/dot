if vim.env.VSCODE then
  vim.g.vscode = true
end

if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("snacks.debug").inspect(...)
end
_G.bt = function(...)
  require("snacks.debug").backtrace()
end
_G.p = function(...)
  require("snacks.debug").profile(...)
end
vim.print = _G.dd

if vim.env.PROF then
  vim.opt.rtp:append("/home/folke/projects/snacks.nvim/")
  require("snacks.profiler").startup({
    startup = {
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
    runtime = "~/projects/neovim/runtime",
  })
end

pcall(require, "config.env")

require("config.lazy").load({
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
