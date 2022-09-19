local indent = 2

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.node_host_prog = "/Users/folke/.pnpm-global/5/node_modules/neovim/bin/cli.js"
vim.opt.autowrite = true -- enable auto write
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.concealcursor = "nc" -- Hide * markup for bold and italic
vim.opt.conceallevel = 3 -- Hide * markup for bold and italic
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs

if vim.fn.has("nvim-0.8") ~= 0 then
  vim.opt.cmdheight = 1
  local keymap_set = vim.keymap.set
  vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    return keymap_set(mode, lhs, rhs, opts)
  end
end
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
-- vim.opt.foldlevel = 6
-- vim.opt.foldmethod = "expr" -- TreeSitter folding
vim.opt.guifont = "FiraCode Nerd Font:h12"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.hidden = true -- Enable modified buffers in background
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = "split" -- preview incremental substitute
vim.opt.joinspaces = false -- No double spaces with join after a dot
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.number = true -- Print line number
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = indent -- Size of an indent
vim.opt.showmode = false -- dont show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically

-- if vim.fn.has("nvim-0.8") == 1 then
--   vim.opt.spell = true -- Put new windows below current
-- end
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = indent -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- save swap file and trigger CursorHold
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.wrap = false -- Disable line wrap
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.fillchars = {
  --   horiz = "━",
  --   horizup = "┻",
  --   horizdown = "┳",
  --   vert = "┃",
  --   vertleft = "┫",
  --   vertright = "┣",
  --   verthoriz = "╋",im.o.fillchars = [[eob: ,
  -- fold = " ",
  foldopen = "",
  -- foldsep = " ",
  foldclose = "",
}
-- vim.o.shortmess = "IToOlxfitn"

-- don't load the plugins below
local builtins = {
  "gzip",
  "zip",
  "zipPlugin",
  "fzf",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "matchit",
  "matchparen",
  "logiPat",
  "rrhelper",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
}

for _, plugin in ipairs(builtins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Use proper syntax highlighting in code blocks
local fences = {
  "lua",
  -- "vim",
  "json",
  "typescript",
  "javascript",
  "js=javascript",
  "ts=typescript",
  "shell=sh",
  "python",
  "sh",
  "console=sh",
}
vim.g.markdown_fenced_languages = fences
