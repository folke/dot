local M = {
  event = "BufReadPost",
}

function M.config()
  local scrollbar = require("scrollbar")

  --- PERF: throttle scrollbar refresh
  local render = scrollbar.render
  scrollbar.render = require("util").throttle(300, render)

  local colors = require("tokyonight.colors").setup()
  scrollbar.setup({
    handle = {
      color = colors.bg_highlight,
    },
    marks = {
      Search = { color = colors.orange },
      Error = { color = colors.error },
      Warn = { color = colors.warning },
      Info = { color = colors.info },
      Hint = { color = colors.hint },
      Misc = { color = colors.purple },
    },
  })
end

return M
