local M = {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = {
    timeout = 3000,
    level = vim.log.levels.INFO,
    fps = 20,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
}

return M
