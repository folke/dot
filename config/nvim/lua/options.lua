local cmd = vim.cmd
local indent = 2

--[[ vim.bo.expandtab = true -- Use spaces instead of tabs
vim.bo.shiftwidth = indent -- Size of an indent
vim.bo.smartindent = true -- Insert indents automatically
vim.bo.undofile = true ]]

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.node_host_prog = "/Users/folke/.pnpm-global/4/node_modules/neovim/bin/cli.js"

vim.o.autowrite = true -- enable auto write
vim.o.clipboard = "unnamedplus" -- sync with system clipboard
vim.o.conceallevel = 2 -- Hide * markup for bold and italic
vim.o.confirm = true -- confirm to save changes before exiting modified buffer
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
vim.o.foldlevel = 6
vim.o.foldmethod = "expr" -- TreeSitter folding
vim.o.guifont = "FiraCode Nerd Font:h12"
vim.o.grepprg = "rg --vimgrep"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.hidden = true -- Enable modified buffers in background
vim.o.ignorecase = true -- Ignore case
vim.o.inccommand = "split" -- preview incremental substitute
vim.o.joinspaces = false -- No double spaces with join after a dot
vim.o.list = true -- Show some invisible characters (tabs...
vim.o.mouse = "a" -- enable mouse mode
vim.o.number = true -- Print line number
vim.o.pumblend = 10 -- Popup blend
vim.o.pumheight = 10 -- Maximum number of entries in a popup
vim.o.relativenumber = true -- Relative line numbers
vim.o.scrolloff = 4 -- Lines of context
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = indent -- Size of an indent
vim.o.showmode = false -- dont show mode since we have a statusline
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.smartcase = true -- Don't ignore case with capitals
vim.o.smartindent = true -- Insert indents automatically
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current
vim.o.tabstop = indent -- Number of spaces tabs count for
vim.o.termguicolors = true -- True color support
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200 -- save swap file and trigger CursorHold
vim.o.wildmode = "list:longest" -- Command-line completion mode
vim.o.wrap = false -- Disable line wrap

-- Check if we need to reload the file when it changed
cmd "au FocusGained * :checktime"

-- syntax
cmd("syntax enable")
cmd("filetype plugin indent on")

-- show cursor line only in active window
vim.api.nvim_exec([[
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline
]], false)

-- go to last loc when opening a buffer
vim.api.nvim_exec([[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]], false)

-- Highlight on yank
cmd("au TextYankPost * lua vim.highlight.on_yank {}")
