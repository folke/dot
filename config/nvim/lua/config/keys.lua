local wk = require("whichkey_setup")
local util = require("util")

vim.g.which_key_centered = 0
vim.g.which_key_fallback_to_native_key = 1
vim.g.which_key_timeout = 50
vim.o.timeoutlen = 300

-- Remove training wheels
util.nmap("<Up>", "<Nop>")
util.nmap("<Down>", "<Nop>")
util.nmap("<Left>", "<Nop>")
util.nmap("<Right>", "<Nop>")

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
    ["v"] = { "<C-W>v", "split-window-below" }
  },
  c = { v = { "<cmd>Vista!!<CR>", "Vista" } },
  b = {
    name = "+buffer",
    ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["d"] = { "<cmd>:bdelete<CR>", "Delete Buffer" },
    ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" }
  },
  g = {
    name = "+git",
    l = { "<cmd>LazyGit<CR>", "LazyGit" },
    g = { "<Cmd>Telescope git_commits<CR>", "commits" },
    c = { "<Cmd>Telescope git_bcommits<CR>", "bcommits" },
    b = { "<Cmd>Telescope git_branches<CR>", "branches" },
    s = { "<Cmd>Telescope git_status<CR>", "status" },
    h = { name = "+hunk" }
  },
  ["h"] = {
    name = "+help",
    t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
    h = { "<cmd>:Telescope help_tags<cr>", "Tags" },
    m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
    k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
    s = { "<cmd>:Telescope highlights<cr>", "Syntax Highlight Groups" },
    f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
    o = { "<cmd>:Telescope vim_options<cr>", "Options" },
    a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" }
  },
  ["f"] = {
    name = "+find",
    t = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Goto Symbol" },
    h = { "<cmd>Telescope command_history<cr>", "Command History" },
    m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
    z = {
      [[<cmd>lua require'telescope'.extensions.z.list{ cmd = { vim.o.shell, "-c", "zoxide query -ls" }}<CR>]],
      "Zoxide"
    }
  },
  [" "] = "Find File",
  [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
  ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
  q = { name = "+quit", q = { "<cmd>:qa<cr>", "Quit" }, ["!"] = { "<cmd>:qa!<cr>", "Quit!" } }
}

wk.register_keymap("leader", leader)

wk.register_keymap("g", { name = "+goto", h = "Hop Word" }, { noremap = true, silent = true })

-- close the locationlist or quickfix window with <esc> or q
vim.cmd [[autocmd FileType qf nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR>]]
vim.cmd [[autocmd FileType qf nnoremap <buffer><silent> q :cclose<bar>lclose<CR>]]

