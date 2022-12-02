local M = {
  "ggandor/leap.nvim",
  event = "User VeryLazy",
  module = "leap",
  dependencies = {
    { "ggandor/flit.nvim", module = "flit" },
    { "ggandor/leap-ast.nvim", module = "leap-ast" },
  },
}

function M.config()
  require("leap").add_default_mappings()
  require("flit").setup({
    labeled_modes = "nv",
  })
  -- require("leap").setup({})
  vim.keymap.set({ "n", "x", "o" }, "M", function()
    require("leap-ast").leap()
  end, {})
end

return M
