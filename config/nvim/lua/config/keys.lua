local wk = require("whichkey_setup")
local util = require("util")

vim.g.which_key_centered = 0
vim.g.which_key_fallback_to_native_key = 1
vim.g.which_key_timeout = 50
vim.g.which_key_use_floating_win = 1
vim.g.which_key_disable_default_offset = 1
vim.o.timeoutlen = 500

-- Resize window
util.nnoremap("<S-Up>", ":resize +2<CR>")
util.nnoremap("<S-Down>", ":resize -2<CR>")
util.nnoremap("<S-Left>", ":vertical resize -2<CR>")
util.nnoremap("<S-Right>", ":vertical resize +2<CR>")

-- Move to window using the movement keys
util.nmap("<Left>", "<C-w>h")
util.nmap("<Down>", "<C-w>j")
util.nmap("<Up>", "<C-w>k")
util.nmap("<Right>", "<C-w>l")

-- better window movement
util.nmap("<C-j>", "<C-d>")
util.nmap("<C-k>", "<C-u>")

-- Move Lines
util.nnoremap("<A-j>", ":m .+1<CR>==")
util.nnoremap("<A-k>", ":m .-2<CR>==")
util.inoremap("<A-j>", "<Esc>:m .+1<CR>==gi")
util.inoremap("<A-k>", "<Esc>:m .-2<CR>==gi")
util.vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
util.vnoremap("<A-k>", ":m '<-2<CR>gv=gv")

-- Clear search with <esc>
util.map("", "<esc>", ":noh<cr>")
util.vnoremap("gw", "*N")

-- makes * and # work on visual mode too.
vim.api.nvim_exec([[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]], false)

local leader = {
  ["w"] = {
    name = "+windows",
    ["w"] = { "<C-W>p", "other-window" },
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
    ["v"] = { "<C-W>v", "split-window-right" }
  },
  c = { v = { "<cmd>Vista!!<CR>", "Vista" } },
  b = {
    name = "+buffer",
    ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
    ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["d"] = { "<cmd>:bd<CR>", "Delete Buffer" },
    ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" }
  },
  g = {
    name = "+git",
    g = { "<cmd>Neogit<CR>", "NeoGit" },
    l = { [[<cmd>lua require"util".float_terminal("lazygit")<CR>]], "LazyGit" },
    c = { "<Cmd>Telescope git_commits<CR>", "commits" },
    b = { "<Cmd>Telescope git_branches<CR>", "branches" },
    s = { "<Cmd>Telescope git_status<CR>", "status" },
    h = { name = "+hunk" }
  },
  ["h"] = {
    name = "+help",
    t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
    c = { "<cmd>:Telescope commands<cr>", "Commands" },
    h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
    m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
    k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
    s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
    l = { [[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor" },
    f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
    o = { "<cmd>:Telescope vim_options<cr>", "Options" },
    a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
    p = {
      name = "+packer",
      p = { "<cmd>PackerSync<cr>", "Sync" },
      s = { "<cmd>PackerStatus<cr>", "Status" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      c = { "<cmd>PackerCompile<cr>", "Compile" }
    }
  },
  u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
  s = {
    name = "+search",
    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Goto Symbol" },
    h = { "<cmd>Telescope command_history<cr>", "Command History" },
    m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
    r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" }
  },
  f = {
    name = "+file",
    t = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    n = { "<cmd>enew<cr>", "New File" },
    z = "Zoxide"
  },
  o = {
    name = "+open",
    p = { "<cmd>MarkdownPreview<cr>", "Markdown Preview" },
    g = { "<cmd>Glow<cr>", "Markdown Glow" }
  },
  p = {
    name = "+project",
    p = "Open Project",
    b = { ":Telescope file_browser cwd=~/projects<CR>", "Browse ~/projects" }
  },
  t = {
    name = "+tabs",
    t = { "<cmd>tabnew<CR>", "New Tab" },
    n = { "<cmd>tabnext<CR>", "Next" },
    p = { "<cmd>tabprevious<CR>", "Previous" },
    ["]"] = { "<cmd>tabnext<CR>", "Next" },
    ["["] = { "<cmd>tabprevious<CR>", "Previous" },
    f = { "<cmd>tabfirst<CR>", "First" },
    l = { "<cmd>tablast<CR>", "Last" }
  },
  ["`"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
  [" "] = "Find File",
  ["."] = { ":Telescope file_browser<CR>", "Browse Files" },
  [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
  ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
  q = {
    name = "+quit/session",
    q = { "<cmd>:qa<cr>", "Quit" },
    ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
    s = { [[<cmd>lua require("config.session").load()<cr>]], "Restore Session" },
    l = { [[<cmd>lua require("config.session").load({last=true})<cr>]], "Restore Last Session" },
    d = { [[<cmd>lua require("config.session").stop()<cr>]], "Stop Current Session" }
  },
  x = {
    name = "+errors",
    x = { "<cmd>LspTroubleToggle<cr>", "Trouble" },
    w = { "<cmd>LspTroubleWorkspaceToggle<cr>", "Workspace Trouble" },
    d = { "<cmd>LspTroubleDocumentToggle<cr>", "Document Trouble" },
    l = { "<cmd>lopen<cr>", "Open Location List" },
    q = { "<cmd>copen<cr>", "Open Quickfix List" }
  },
  z = { [[<cmd>lua require("util").zen_mode()<cr>]], "Zen Mode" }
}

for i = 0, 10 do leader[tostring(i)] = "which_key_ignore" end

wk.register_keymap("leader", leader)

wk.register_keymap("g", {
  name = "+goto",
  h = "Hop Word",
  x = "Open",
  -- ignore whichkey for comments
  c = "which_key_ignore",
  ["cc"] = "which_key_ignore"
}, { noremap = true, silent = true })

-- close the locationlist or quickfix window with <esc> or q
-- vim.cmd [[autocmd FileType qf nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR>]]
-- vim.cmd [[autocmd FileType qf nnoremap <buffer><silent> q :cclose<bar>lclose<CR>]]
vim.cmd [[autocmd FileType help,startuptime,qf,lspinfo nnoremap <buffer><silent> q :close<CR>]]

