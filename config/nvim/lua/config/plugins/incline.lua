local M = {
  "b0o/incline.nvim",
  event = "BufReadPre",
}

function M.config()
  if vim.g.started_by_firenvim then
    return
  end

  local colors = require("tokyonight.colors").setup()

  require("incline").setup({
    highlight = {
      groups = {
        InclineNormal = {
          guibg = "#FC56B1",
          guifg = colors.black,
          -- gui = "bold",
        },
        InclineNormalNC = {
          guifg = "#FC56B1",
          guibg = colors.black,
        },
      },
    },
    window = {
      margin = {
        vertical = 0,
        horizontal = 1,
      },
    },
    render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      local icon, color = require("nvim-web-devicons").get_icon_color(filename)
      return {
        { icon, guifg = color },
        { " " },
        { filename },
      }
    end,
  })
end

return M
