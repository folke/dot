return {
  module = "nvim-autopairs",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup()
  end,
}
