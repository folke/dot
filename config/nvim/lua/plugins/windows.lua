local M = {
  event = "User PackerDefered",
  requires = {
    { "anuvyklack/middleclass", module = "middleclass" },
    { "anuvyklack/animation.nvim", module = "animation" },
  },
}

function M.config()
  vim.o.winwidth = 5
  vim.o.winminwidth = 5
  vim.o.equalalways = false
  require("windows").setup({
    animation = {
      duration = 150,
    },
  })
  vim.keymap.set("n", "<leader>Z", "<Cmd>WindowsMaximize<CR>")
end

return M
