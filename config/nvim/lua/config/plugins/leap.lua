local M = {
  event = "User VeryLazy",
  module = "leap",
  requires = {
    { "ggandor/flit.nvim", module = "flit" },
    { "ggandor/leap-ast.nvim", module = "leap-ast" },
  },
}

function M.config()
  require("leap").add_default_mappings()
  -- require("flit").setup()
  -- require("leap").setup({})
  vim.keymap.set({ "n", "x", "o" }, "M", function()
    require("leap-ast").leap()
  end, {})
end

return M
