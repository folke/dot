local M = {
  module = "noice",
  event = "VimEnter",
}

function M.config()
  require("noice").setup({ debug = true })
        IncRename = {
          pattern = "^:%s*IncRename%s+",
          icon = " ",
          conceal = true,
          opts = {
            relative = "cursor",
            size = { min_width = 20 },
            position = { row = -3, col = 0 },
            buf_options = { filetype = "text" },
          },
        },
end

return M
