" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["colorbuddy.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/colorbuddy.nvim"
  },
  ["dashboard-nvim"] = {
    config = { "require('config.dashboard')" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  edge = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/edge"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.gitsigns\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/glow.nvim"
  },
  hop = {
    config = { "\27LJ\2\nk\0\0\4\0\a\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0'\2\5\0B\0\2\0029\0\6\0004\2\0\0B\0\2\1K\0\1\0\nsetup\bhop\17:HopWord<CR>\agh\tnmap\tutil\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/hop"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.blankline\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  kommentary = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.comments\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/kommentary"
  },
  ["lazygit.nvim"] = {
    config = { "\27LJ\2\nE\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0(lazygit_floating_window_use_plenary\6g\bvim\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/lazygit.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.lsp.saga\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["lualine.nvim"] = {
    config = { "require('config.lualine')" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["material.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/material.nvim"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18config.scroll\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.autopairs\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-base16"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-base16"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22config.bufferline\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.colorizer\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.compe\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lsp-ts-utils"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-lsp-ts-utils"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15config.lsp\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-toggleterm.lua"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.terminal\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-toggleterm.lua"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle" },
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16config.tree\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "require('config.treesitter')" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring"
  },
  ["nvim-ts-rainbow"] = {
    config = { "\27LJ\2\ng\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\frainbow\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["nvim-web-nonicons"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-web-nonicons"
  },
  ["nvim-whichkey-setup.lua"] = {
    config = { "require('config.keys')" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-whichkey-setup.lua"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["specs.nvim"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.specs\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/specs.nvim"
  },
  ["sql.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/sql.nvim"
  },
  tabular = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/tabular"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim"
  },
  ["telescope-z.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/telescope-z.nvim"
  },
  ["telescope.nvim"] = {
    commands = { "Telescope" },
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.telescope\frequire\0" },
    keys = { { "", "<leader><space>" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ["train.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/train.nvim"
  },
  vim = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim"
  },
  ["vim-dogrun"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-dogrun"
  },
  ["vim-markdown"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.markdown\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-markdown"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-obsession"
  },
  ["vim-prosession"] = {
    config = { "\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19config.session\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-prosession"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-which-key"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    config = { "\27LJ\2\nB\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\rnvim_lsp\28vista_default_executive\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/vista.vim"
  },
  ["zephyr-nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/zephyr-nvim"
  }
}

-- Config for: nvim-toggleterm.lua
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.terminal\frequire\0", "config", "nvim-toggleterm.lua")
-- Config for: nvim-compe
try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.compe\frequire\0", "config", "nvim-compe")
-- Config for: lualine.nvim
require('config.lualine')
-- Config for: indent-blankline.nvim
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.blankline\frequire\0", "config", "indent-blankline.nvim")
-- Config for: specs.nvim
try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.specs\frequire\0", "config", "specs.nvim")
-- Config for: dashboard-nvim
require('config.dashboard')
-- Config for: nvim-bufferline.lua
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22config.bufferline\frequire\0", "config", "nvim-bufferline.lua")
-- Config for: vim-prosession
try_loadstring("\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19config.session\frequire\0", "config", "vim-prosession")
-- Config for: lazygit.nvim
try_loadstring("\27LJ\2\nE\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0(lazygit_floating_window_use_plenary\6g\bvim\0", "config", "lazygit.nvim")
-- Config for: nvim-autopairs
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.autopairs\frequire\0", "config", "nvim-autopairs")
-- Config for: neoscroll.nvim
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18config.scroll\frequire\0", "config", "neoscroll.nvim")
-- Config for: lspsaga.nvim
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.lsp.saga\frequire\0", "config", "lspsaga.nvim")
-- Config for: nvim-whichkey-setup.lua
require('config.keys')
-- Config for: nvim-lspconfig
try_loadstring("\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15config.lsp\frequire\0", "config", "nvim-lspconfig")
-- Config for: nvim-colorizer.lua
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.colorizer\frequire\0", "config", "nvim-colorizer.lua")
-- Config for: nvim-ts-rainbow
try_loadstring("\27LJ\2\ng\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\frainbow\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-ts-rainbow")
-- Config for: lspkind-nvim
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
-- Config for: nvim-treesitter
require('config.treesitter')
-- Config for: kommentary
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.comments\frequire\0", "config", "kommentary")
-- Config for: hop
try_loadstring("\27LJ\2\nk\0\0\4\0\a\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0'\2\5\0B\0\2\0029\0\6\0004\2\0\0B\0\2\1K\0\1\0\nsetup\bhop\17:HopWord<CR>\agh\tnmap\tutil\frequire\0", "config", "hop")
-- Config for: gitsigns.nvim
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.gitsigns\frequire\0", "config", "gitsigns.nvim")
-- Config for: vim-markdown
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.markdown\frequire\0", "config", "vim-markdown")

-- Command lazy-loads
vim.cmd [[command! -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]

-- Keymap lazy-loads
vim.cmd [[noremap <silent> <leader><space> <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>leader><lt>space>", prefix = "" }, _G.packer_plugins)<cr>]]

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
