return {
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  module = "diffview",
  config = function()
    require("diffview").setup({})
  end,
}
