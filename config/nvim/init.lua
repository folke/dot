-- vim.opt.runtimepath:prepend("~/projects/lazy.nvim")
-- require("lazy").setup({
--
--   "nvim-telescope/telescope.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
--     { "nvim-telescope/telescope-frecency.nvim", dependencies = "kkharji/sqlite.lua" },
--   },
-- })
--
-- if true then
--   return
-- end

local util = require("util")
local require = util.require

require("config.options")
require("config.lazy")
require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    util.version()
    require("config.commands")
    require("config.mappings")
  end,
})
