local wk = require("whichkey_setup")

vim.g.which_key_centered = 0
vim.o.timeoutlen = 500

local leader = {
  ["w"] = {
    name = "+windows",
    ["w"] = { "<C-W>w", "other-window" },
    ["d"] = { "<C-W>c", "delete-window" },
    ["-"] = { "<C-W>s", "split-window-below" },
    ["|"] = { "<C-W>v", "split-window-right" },
    ["2"] = { "<C-W>v", "layout-double-columns" },
    ["h"] = { "<C-W>h", "window-left" },
    ["j"] = { "<C-W>j", "window-below" },
    ["l"] = { "<C-W>l", "window-right" },
    ["k"] = { "<C-W>k", "window-up" },
    ["H"] = { "<C-W>5<", "expand-window-left" },
    ["J"] = { ":resize +5", "expand-window-below" },
    ["L"] = { "<C-W>5>", "expand-window-right" },
    ["K"] = { ":resize -5", "expand-window-up" },
    ["="] = { "<C-W>=", "balance-window" },
    ["s"] = { "<C-W>s", "split-window-below" },
    ["v"] = { "<C-W>v", "split-window-below" },
    ["?"] = { "Windows", "fzf-window" }
  },
  ["`"] = "Toggle Terminal",
  ["f"] = {
    name = "+find",
    ["t"] = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
    ["f"] = { "<cmd>Telescope find_files<cr>", "Find File" },
    ["r"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    ["g"] = { "<cmd>Telescope live_grep<cr>", "Grep" }
  },
  [" "] = "Find File",
  [","] = { "<cmd>Telescope buffers<cr>", "Switch Buffer" },
  ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
  qq = { "<cmd>:qa<cr>", "Quit" }
}

wk.register_keymap("leader", leader)
