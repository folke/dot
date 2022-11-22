return {
  cmd = "Neotree",
  config = function()
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    require("neo-tree").setup({ filesystem = { follow_current_file = true } })
  end,
}
