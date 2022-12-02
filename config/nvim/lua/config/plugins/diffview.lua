return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  module = "diffview",
  config = function()
    require("diffview").setup({})
  end,
}
