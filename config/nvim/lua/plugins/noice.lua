local M = {
  -- module = "noice",
  opt = false,
  -- event = "User PackerDefered",
}

function M.config()
  require("noice").setup({
    debug = true,
    cmdline = {
      format = {
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
      },
    },
  })
  -- require("telescope").load_extension("noice")
end

return M
