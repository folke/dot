require("util.debug")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

require("config.options")
require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
    require("config.commands")
    require("config.mappings")
  end,
})
