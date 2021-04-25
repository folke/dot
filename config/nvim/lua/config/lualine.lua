local function clock() return " " .. os.date("%H:%M") end

local config = {
  options = {
    theme = "tokyonight",
    section_separators = { "", "" },
    component_separators = { "", "" },
    -- section_separators = { "", "" },
    -- component_separators = { "", "" },
    icons_enabled = true
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "diagnostics", sources = { "nvim_lsp" } }, "filename" },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { clock }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { "nvim-tree" }
}

-- try to load matching lualine theme

local M = {}

function M.load()
  local name = vim.g.colors_name
  local ok, _ = pcall(require, "lualine.themes." .. name)
  if ok then config.options.theme = name end
  require("lualine").setup(config)
end

M.load()

-- vim.api.nvim_exec([[
--   autocmd ColorScheme * lua require("config.lualine").load();
-- ]], false)

return M

