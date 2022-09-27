local M = { event = "User PackerDefered" }

local function clock()
  return " " .. os.date("%H:%M")
end

local function holidays()
  return "🌴🌊"
  -- return "🎅🎄🌟🎁"
end

function M.config()
  require("lualine").setup({
    options = {
      theme = "auto",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      icons_enabled = true,
      globalstatus = true,
      disabled_filetypes = { statusline = { "dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        { "diagnostics", sources = { "nvim_diagnostic" } },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        {
          function()
            local navic = require("nvim-navic")
            local ret = navic.get_location()
            return ret:len() > 2000 and "navic error" or ret
          end,
          cond = function()
            local navic = require("nvim-navic")
            return navic.is_available()
          end,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_x = {
        {
          require("noice.status").message.get_hl,
          cond = require("noice.status").message.has,
        },
        {
          require("noice.status").command.get,
          cond = require("noice.status").command.has,
          color = { fg = "#ff9e64" },
        },
        {
          require("noice.status").mode.get,
          cond = require("noice.status").mode.has,
          color = { fg = "#ff9e64" },
        },
        {
          require("noice.status").search.get,
          cond = require("noice.status").search.has,
          color = { fg = "#ff9e64" },
        },
        -- function()
        --   return require("messages.view").status
        -- end,
        { require("github-notifications").statusline_notification_count },
        { holidays },
      },
      lualine_y = { "location" },
      lualine_z = { clock },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "nvim-tree" },
  })
end

return M
