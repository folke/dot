return {
  module = "nvim-autopairs",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string", "comment" }, -- it will not add a pair on that treesitter node
      },
    })
  end,
}
