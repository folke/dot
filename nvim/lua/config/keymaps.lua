local util = require("util")

util.cowboy()
util.wezterm()

-- change word with <c-c>
vim.keymap.set("n", "<C-c>", "<cmd>normal! ciw<cr>a")
