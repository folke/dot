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
  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time("Luarocks path setup", true)
local package_path_str = "/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/folke/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  ["dashboard-nvim"] = {
    config = { "require('config.dashboard')" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  ["diffview.nvim"] = {
    commands = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.diffview\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/diffview.nvim"
  },
  ["friendly-snippets"] = {
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    wants = { "plenary.nvim" }
  },
  ["glow.nvim"] = {
    commands = { "Glow" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/glow.nvim"
  },
  gruvbox = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/gruvbox"
  },
  ["hop.nvim"] = {
    commands = { "HopWord", "HopChar1" },
    config = { "\27LJ\2\no\0\0\4\0\a\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0'\2\5\0B\0\2\0029\0\6\0004\2\0\0B\0\2\1K\0\1\0\nsetup\bhop\21<cmd>HopWord<CR>\agh\tnmap\tutil\frequire\0" },
    keys = { { "", "gh" }, { "", "s" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/hop.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.blankline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim"
  },
  kommentary = {
    after = { "nvim-ts-context-commentstring" },
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.comments\frequire\0" },
    keys = { { "", "gc" }, { "", "gcc" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/kommentary",
    wants = { "nvim-ts-context-commentstring" }
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim"
  },
  ["lspsaga.nvim"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/lspsaga.nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "require('config.lualine')" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["luv-vimdocs"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/luv-vimdocs"
  },
  ["markdown-preview.nvim"] = {
    commands = { "MarkdownPreview" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  ["material.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/material.nvim"
  },
  ["moonlight.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/moonlight.nvim"
  },
  neogit = {
    commands = { "Neogit" },
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18config.neogit\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18config.scroll\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nord.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nord.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.autopairs\frequire\0" },
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22config.bufferline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.colorizer\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    after = { "nvim-autopairs", "vim-vsnip-integ", "friendly-snippets", "vim-vsnip" },
    after_files = { "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.compe\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-compe",
    wants = { "vim-vsnip", "vim-vsnip-integ", "friendly-snippets" }
  },
  ["nvim-lsp-ts-utils"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-lsp-ts-utils"
  },
  ["nvim-lspconfig"] = {
    after = { "lspsaga.nvim", "nvim-lspinstall", "nvim-lsp-ts-utils" },
    config = { "\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15config.lsp\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig",
    wants = { "nvim-lspinstall" }
  },
  ["nvim-lspinstall"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-lspinstall"
  },
  ["nvim-spectre"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-spectre",
    wants = { "plenary.nvim", "popup.nvim" }
  },
  ["nvim-toggleterm.lua"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.terminal\frequire\0" },
    keys = { { "", "<M-`>" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-toggleterm.lua"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle", "NvimTreeClose" },
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
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-ts-context-commentstring"] = {
    load_after = {
      kommentary = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\fdefault\2\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["onedark.vim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/onedark.vim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  sonokai = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/sonokai"
  },
  ["specs.nvim"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.specs\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/specs.nvim"
  },
  ["symbols-outline.nvim"] = {
    commands = { "SymbolsOutline" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/symbols-outline.nvim"
  },
  tabular = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/tabular"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/targets.vim"
  },
  ["telescope-fzy-native.nvim"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/telescope-fzy-native.nvim"
  },
  ["telescope-project.nvim"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim"
  },
  ["telescope-symbols.nvim"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/telescope-symbols.nvim"
  },
  ["telescope-z.nvim"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/telescope-z.nvim"
  },
  ["telescope.nvim"] = {
    after = { "telescope-z.nvim", "telescope-fzy-native.nvim", "telescope-project.nvim", "telescope-symbols.nvim" },
    commands = { "Telescope" },
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.telescope\frequire\0" },
    keys = { { "", "<leader><space>" }, { "", "<leader>fz" }, { "", "<leader>pp" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    wants = { "plenary.nvim", "popup.nvim", "telescope-z.nvim", "telescope-fzy-native.nvim", "telescope-project.nvim", "trouble.nvim", "telescope-symbols.nvim" }
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16config.todo\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/todo-comments.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "TroubleToggle", "Trouble" },
    config = { "\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\14auto_open\1\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/trouble.nvim"
  },
  ["twilight.nvim"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/twilight.nvim"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/undotree"
  },
  ["vim-fish"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-fish"
  },
  ["vim-illuminate"] = {
    config = { "\27LJ\2\n2\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1è\3=\1\2\0K\0\1\0\21Illuminate_delay\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/vim-illuminate"
  },
  ["vim-markdown"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.markdown\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-markdown"
  },
  ["vim-nix"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-nix"
  },
  ["vim-obsession"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/vim-obsession"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/vim-startuptime"
  },
  ["vim-tips-wiki"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-tips-wiki"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/vim-unimpaired"
  },
  ["vim-vsnip"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.snippets\frequire\0" },
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    after_files = { "/Users/folke/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ/after/plugin/vsnip_integ.vim" },
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16config.keys\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  },
  ["zen-mode.nvim"] = {
    config = { "\27LJ\2\n‚\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\fplugins\1\0\0\nkitty\1\0\2\tfont\a+2\fenabled\1\1\0\2\ttmux\2\rgitsigns\2\nsetup\rzen-mode\frequire\0" },
    loaded = true,
    path = "/Users/folke/.local/share/nvim/site/pack/packer/start/zen-mode.nvim"
  }
}

time("Defining packer_plugins", false)
local module_lazy_loads = {
  ["^folke%.util"] = "nvim-toggleterm.lua",
  ["^spectre"] = "nvim-spectre"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat)then
      to_load[#to_load + 1] = plugin_name
    end
  end

  require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: vim-obsession
time("Setup for vim-obsession", true)
try_loadstring("\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19config.session\frequire\0", "setup", "vim-obsession")
time("Setup for vim-obsession", false)
time("packadd for vim-obsession", true)
vim.cmd [[packadd vim-obsession]]
time("packadd for vim-obsession", false)
-- Config for: vim-markdown
time("Config for vim-markdown", true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.markdown\frequire\0", "config", "vim-markdown")
time("Config for vim-markdown", false)
-- Config for: todo-comments.nvim
time("Config for todo-comments.nvim", true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16config.todo\frequire\0", "config", "todo-comments.nvim")
time("Config for todo-comments.nvim", false)
-- Config for: lualine.nvim
time("Config for lualine.nvim", true)
require('config.lualine')
time("Config for lualine.nvim", false)
-- Config for: which-key.nvim
time("Config for which-key.nvim", true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16config.keys\frequire\0", "config", "which-key.nvim")
time("Config for which-key.nvim", false)
-- Config for: neoscroll.nvim
time("Config for neoscroll.nvim", true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18config.scroll\frequire\0", "config", "neoscroll.nvim")
time("Config for neoscroll.nvim", false)
-- Config for: dashboard-nvim
time("Config for dashboard-nvim", true)
require('config.dashboard')
time("Config for dashboard-nvim", false)
-- Config for: specs.nvim
time("Config for specs.nvim", true)
try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.specs\frequire\0", "config", "specs.nvim")
time("Config for specs.nvim", false)
-- Config for: nvim-treesitter
time("Config for nvim-treesitter", true)
require('config.treesitter')
time("Config for nvim-treesitter", false)
-- Config for: nvim-web-devicons
time("Config for nvim-web-devicons", true)
try_loadstring("\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\fdefault\2\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time("Config for nvim-web-devicons", false)
-- Config for: zen-mode.nvim
time("Config for zen-mode.nvim", true)
try_loadstring("\27LJ\2\n‚\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\fplugins\1\0\0\nkitty\1\0\2\tfont\a+2\fenabled\1\1\0\2\ttmux\2\rgitsigns\2\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time("Config for zen-mode.nvim", false)

-- Command lazy-loads
time("Defining lazy-load commands", true)
vim.cmd [[command! -nargs=* -range -bang -complete=file MarkdownPreview lua require("packer.load")({'markdown-preview.nvim'}, { cmd = "MarkdownPreview", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewOpen lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewClose lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewToggleFiles lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewToggleFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewFocusFiles lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewFocusFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file TroubleToggle lua require("packer.load")({'trouble.nvim'}, { cmd = "TroubleToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Trouble lua require("packer.load")({'trouble.nvim'}, { cmd = "Trouble", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file SymbolsOutline lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutline", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Neogit lua require("packer.load")({'neogit'}, { cmd = "Neogit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Glow lua require("packer.load")({'glow.nvim'}, { cmd = "Glow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file NvimTreeClose lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file HopWord lua require("packer.load")({'hop.nvim'}, { cmd = "HopWord", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file HopChar1 lua require("packer.load")({'hop.nvim'}, { cmd = "HopChar1", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time("Defining lazy-load commands", false)

-- Keymap lazy-loads
time("Defining lazy-load keymaps", true)
vim.cmd [[noremap <silent> <M-`> <cmd>lua require("packer.load")({'nvim-toggleterm.lua'}, { keys = "<lt>M-`>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gh <cmd>lua require("packer.load")({'hop.nvim'}, { keys = "gh", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> s <cmd>lua require("packer.load")({'hop.nvim'}, { keys = "s", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gcc <cmd>lua require("packer.load")({'kommentary'}, { keys = "gcc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gc <cmd>lua require("packer.load")({'kommentary'}, { keys = "gc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader><space> <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>leader><lt>space>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>fz <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>leader>fz", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>pp <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>leader>pp", prefix = "" }, _G.packer_plugins)<cr>]]
time("Defining lazy-load keymaps", false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time("Defining lazy-load filetype autocommands", true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time("Defining lazy-load filetype autocommands", false)
  -- Event lazy-loads
time("Defining lazy-load event autocommands", true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'nvim-colorizer.lua', 'lspsaga.nvim', 'indent-blankline.nvim', 'nvim-bufferline.lua', 'nvim-lspconfig', 'gitsigns.nvim', 'vim-illuminate', 'trouble.nvim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
time("Defining lazy-load event autocommands", false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
