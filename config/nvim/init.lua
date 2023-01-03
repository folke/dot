local debug = require("util.debug")

if vim.env.VIMCONFIG then
  return debug.switch(vim.env.VIMCONFIG)
end

vim.g.mapleader = " "
require("config.lazy")

-- require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
