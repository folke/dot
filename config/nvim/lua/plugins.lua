local packer = require("packer")

local config = {
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
}

local locals = { folke = true, ["nvim-compe"] = true, ["null-ls.nvim"] = true }

local function get_name(pkg)
  local parts = vim.split(pkg, "/")
  return parts[#parts], parts[1]
end

local function has_local(name)
  return vim.loop.fs_stat(vim.fn.expand("~/projects/" .. name)) ~= nil
end

local function process(spec)
  if type(spec) == "string" then
    local name, owner = get_name(spec)
    local local_pkg = "~/projects/" .. name

    if locals[name] or locals[owner] then
      return local_pkg
    end
    -- if has_local(name) then
    --   dump(spec)
    -- end
    return spec
  else
    for i, s in ipairs(spec) do
      spec[i] = process(s)
    end
  end
  if spec.requires then
    spec.requires = process(spec.requires)
  end
  return spec
end

local function wrap(use)
  return function(spec)
    spec = process(spec)
    use(spec)
  end
end

return packer.startup({
  function(use)
    use = wrap(use)

    -- Packer can manage itself as an optional plugin
    use({ "wbthomason/packer.nvim", opt = true })

    -- LSP
    use({
      "neovim/nvim-lspconfig",
      opt = true,
      event = "BufReadPre",
      wants = { "nvim-lsp.json", "nvim-lsp-ts-utils", "null-ls.nvim", "lua-dev.nvim" },
      config = function()
        require("config.lsp")
      end,
      requires = {
        "folke/nvim-lsp.json",
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        "jose-elias-alvarez/null-ls.nvim",
        "folke/lua-dev.nvim",
      },
    })

    use({
      "hrsh7th/nvim-compe",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.compe")
      end,
      wants = { "LuaSnip" },
      requires = {
        {
          "L3MON4D3/LuaSnip",
          wants = "friendly-snippets",
          config = function()
            require("config.snippets")
          end,
        },
        "rafamadriz/friendly-snippets",
        {
          "windwp/nvim-autopairs",
          config = function()
            require("config.autopairs")
          end,
        },
      },
    })

    use({
      "simrat39/symbols-outline.nvim",
      cmd = { "SymbolsOutline" },
    })

    use({
      "b3nj5m1n/kommentary",
      opt = true,
      wants = "nvim-ts-context-commentstring",
      keys = { "gc", "gcc" },
      config = function()
        require("config.comments")
      end,
      requires = "JoosepAlviste/nvim-ts-context-commentstring",
    })

    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      opt = true,
      event = "BufRead",
      requires = {
        { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      config = [[require('config.treesitter')]],
    })

    -- Theme: color schemes
    -- use("tjdevries/colorbuddy.vim")
    use({
      -- "shaunsingh/nord.nvim",
      -- "shaunsingh/moonlight.nvim",
      -- { "olimorris/onedark.nvim", requires = "rktjmp/lush.nvim" },
      -- "joshdick/onedark.vim",
      -- "wadackel/vim-dogrun",
      -- { "npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim" },
      -- "bluz71/vim-nightfly-guicolors",
      -- { "marko-cerovac/material.nvim" },
      -- "sainnhe/edge",
      -- { "embark-theme/vim", as = "embark" },
      -- "norcalli/nvim-base16.lua",
      -- "RRethy/nvim-base16",
      -- "novakne/kosmikoa.nvim",
      -- "glepnir/zephyr-nvim",
      -- "ghifarit53/tokyonight-vim"
      -- "sainnhe/sonokai",
      -- "morhetz/gruvbox",
      -- "arcticicestudio/nord-vim",
      -- "drewtempelmeyer/palenight.vim",
      -- "Th3Whit3Wolf/onebuddy",
      -- "christianchiarulli/nvcode-color-schemes.vim",
      -- "Th3Whit3Wolf/one-nvim"

      "folke/tokyonight.nvim",
      -- event = "VimEnter",
      config = function()
        require("config.theme")
      end,
    })

    -- Theme: icons
    use({
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({ default = true })
      end,
    })

    -- Dashboard
    use({ "glepnir/dashboard-nvim", config = [[require('config.dashboard')]] })

    use({
      "norcalli/nvim-terminal.lua",
      ft = "terminal",
      config = function()
        require("terminal").setup()
      end,
    })
    use({ "nvim-lua/plenary.nvim", module = "plenary" })
    use({ "nvim-lua/popup.nvim", module = "popup" })

    use({
      "windwp/nvim-spectre",
      opt = true,
      module = "spectre",
      wants = { "plenary.nvim", "popup.nvim" },
      requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
    })

    use({
      "kyazdani42/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      config = function()
        require("config.tree")
      end,
    })

    -- Fuzzy finder
    use({
      "nvim-telescope/telescope.nvim",
      opt = true,
      config = function()
        require("config.telescope")
      end,
      cmd = { "Telescope" },
      keys = { "<leader><space>", "<leader>fz", "<leader>pp" },
      wants = {
        "plenary.nvim",
        "popup.nvim",
        "telescope-z.nvim",
        -- "telescope-frecency.nvim",
        "telescope-fzy-native.nvim",
        "telescope-project.nvim",
        "trouble.nvim",
        "telescope-symbols.nvim",
      },
      requires = {
        "nvim-telescope/telescope-z.nvim",
        "nvim-telescope/telescope-project.nvim",
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-symbols.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
        -- { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sql.nvim" }
      },
    })

    -- Indent Guides and rainbow brackets
    use({
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      branch = "lua",
      config = function()
        require("config.blankline")
      end,
    })

    -- Tabs
    use({
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      config = function()
        require("config.bufferline")
      end,
    })

    -- Terminal
    use({
      "akinsho/nvim-toggleterm.lua",
      keys = "<M-`>",
      config = function()
        require("config.terminal")
      end,
    })

    -- Smooth Scrolling
    use({
      "karb94/neoscroll.nvim",
      keys = { "<C-u>", "<C-d>", "gg", "G" },
      config = function()
        require("config.scroll")
      end,
    })
    use({
      "edluffy/specs.nvim",
      after = "neoscroll.nvim",
      config = function()
        require("config.specs")
      end,
    })
    -- use { "Xuyuanp/scrollbar.nvim", config = function() require("config.scrollbar") end }

    -- Git Gutter
    use({
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      wants = "plenary.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.gitsigns")
      end,
    })
    -- use {
    --   "kdheepak/lazygit.nvim",
    --   cmd = "LazyGit",
    --   config = function() vim.g.lazygit_floating_window_use_plenary = 0 end
    -- }
    use({
      "TimUntersberger/neogit",
      cmd = "Neogit",
      config = function()
        require("config.neogit")
      end,
    })

    -- Statusline
    use({
      "hoob3rt/lualine.nvim",
      event = "VimEnter",
      config = [[require('config.lualine')]],
      wants = "nvim-web-devicons",
    })

    use({
      "norcalli/nvim-colorizer.lua",
      event = "BufReadPre",
      config = function()
        require("config.colorizer")
      end,
    })

    use({ "npxbr/glow.nvim", cmd = "Glow" })

    use({
      "plasticboy/vim-markdown",
      opt = true,
      requires = "godlygeek/tabular",
      ft = "markdown",
    })
    use({
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      cmd = "MarkdownPreview",
    })

    -- use { "tjdevries/train.nvim", cmd = { "TrainClear", "TrainTextObj", "TrainUpDown", "TrainWord" } }

    -- use({ "wfxr/minimap.vim", config = function()
    --   require("config.minimap")
    -- end })

    use({
      "phaazon/hop.nvim",
      keys = { "gh", "s" },
      cmd = { "HopWord", "HopChar1" },
      config = function()
        require("util").nmap("gh", "<cmd>HopWord<CR>")
        -- require("util").nmap("s", "<cmd>HopChar1<CR>")
        -- you can configure Hop the way you like here; see :h hop-config
        require("hop").setup({})
      end,
    })

    use({
      "folke/trouble.nvim",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup({ auto_open = false })
      end,
    })

    use({
      "folke/session.nvim",
      event = "BufReadPre",
      module = "session",
      config = function()
        require("session").start()
      end,
    })

    use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

    use({ "mbbill/undotree", cmd = "UndotreeToggle" })

    use({ "mjlbach/babelfish.nvim", module = "babelfish" })

    use({
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      opt = true,
      requires = { "folke/twilight.nvim" },
      config = function()
        require("zen-mode").setup({
          plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } },
        })
      end,
    })

    use({
      "folke/todo-comments.nvim",
      cmd = { "TodoTrouble", "TodoTelescope" },
      config = function()
        require("config.todo")
      end,
    })

    use({
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        require("config.keys")
      end,
    })

    use({
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
      config = function()
        require("config.diffview")
      end,
    })

    use({
      "RRethy/vim-illuminate",
      event = "CursorHold",
      module = "illuminate",
      config = function()
        vim.g.Illuminate_delay = 1000
      end,
    })

    -- use({ "wellle/targets.vim" })

    -- use("DanilaMihailov/vim-tips-wiki")
    use("nanotee/luv-vimdocs")
    use({
      "andymass/vim-matchup",
      event = "CursorMoved",
    })
  end,
  config = config,
})
