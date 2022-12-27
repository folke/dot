local M = {
  enabled = true,
  "anuvyklack/windows.nvim",
  event = "WinNew",
  dependencies = {
    { "anuvyklack/middleclass" },
    { "anuvyklack/animation.nvim", enabled = false },
  },
}

function M.config()
  vim.o.winwidth = 5
  vim.o.winminwidth = 5
  vim.o.equalalways = false
  require("windows").setup({
    animation = {
      enable = false,
      duration = 150,
    },
  })
  vim.keymap.set("n", "<leader>Z", "<Cmd>WindowsMaximize<CR>")
end

return M
