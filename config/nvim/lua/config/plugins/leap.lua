local M = {
  "ggandor/leap.nvim",
  event = "VeryLazy",

  dependencies = {
    { "ggandor/flit.nvim" },
    { "ggandor/leap-ast.nvim" },
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
