require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
  },
  filters = {
    custom = { ".git", "node_modules", ".cargo" },
  },
})
