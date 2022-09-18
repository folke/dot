return {
  module = "neorg",
  ft = "norg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.completion"] = {
          config = { engine = "nvim-cmp" },
        },
        ["core.integrations.nvim-cmp"] = {},
      },
    })
  end,
}
