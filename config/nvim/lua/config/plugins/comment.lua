local M = {
  keys = { "gc", "gcc", "gbc" },
  requires = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      module = "ts_context_commentstring",
    },
  },
}

function M.config()
  require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  })
end

return M
