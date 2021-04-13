vim.g.material_style = "palenight"
vim.g.material_italic_comments = 1
vim.g.material_italic_keywords = 1
vim.g.material_italic_functions = 1
vim.g.material_lsp_underline = 0

vim.g.sonokai_style = "atlantis"
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_disable_italic_comment = 1

vim.g.edge_style = "neon"
vim.g.edge_enable_italic = 1
vim.g.edge_disable_italic_comment = 0
vim.g.edge_transparent_background = 0

vim.g.embark_terminal_italics = 1

vim.g.nvcode_termcolors = 256

-- require("config.diagnostics")

-- require("colorbuddy").colorscheme("onebuddy")

-- vim.cmd("colorscheme material") -- Put your favorite colorscheme here

-- vim.cmd [[
--   highlight! link LspDiagnosticsDefaultError LspDiagnosticsError
--   highlight! link LspDiagnosticsDefaultWarning LspDiagnosticsWarning
--   highlight! link LspDiagnosticsUnderlineError LspDiagnosticsError
--   highlight LspDiagnosticsUnderlineError gui=undercurl
-- ]]

-- vim.cmd("highlight Normal guibg=none") -- make background transparent

require"base16-colorscheme".setup "material-palenight"

-- vim.cmd([[hi LineNr guibg=NONE]])
-- vim.cmd([[hi SignColumn guibg=NONE]])

