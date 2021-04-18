require("lualine").setup({
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
    lualine_b = { "branch", { "diagnostics", sources = { "nvim_lsp" } } },
    lualine_c = { "filename" },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  }
})

-- Show minimal border for inactive windows
vim.api.nvim_exec([[
    highlight! lualine_a_inactive gui=underline guibg=NONE guisp=#0d0f17
    highlight! lualine_b_inactive gui=underline guibg=NONE guisp=#0d0f17
    highlight! lualine_c_inactive gui=underline guibg=NONE guisp=#0d0f17
]], false)

