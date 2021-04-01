vim.api.nvim_set_keymap("n", "<Leader>", [[:<c-u>WhichKey '<Space>'<CR>]],
                        { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Leader>", [[:silent <c-u> :silent WhichKeyVisual '<Space>'<CR>]],
                        { noremap = true, silent = true })

vim.g.which_key_map = {
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
  ["f"] = {
    name = "+find",
    ["t"] = { ":NvimTreeToggle", "NvimTree" },
    ["f"] = { ":Telescope find_files", "Find File" },
    ["r"] = { ":Telescope oldfiles", "Open Recent File" },
    ["g"] = { ":Telescope live_grep", "Grep" }
  },
  [" "] = { ":Telescope find_files", "Find File" },
  [","] = { ":Telescope buffers", "Switch Buffer" },
  ["/"] = { ":Telescope live_grep", "Search" }
}
vim.call("which_key#register", "<Space>", "g:which_key_map")

-- vim.api.nvim_set_keymap('n', '<Leader>w', [[<C-w>]], {noremap = true})
