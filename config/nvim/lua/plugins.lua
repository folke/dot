local packer = require("util.packer")

local config = {
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
  },
  opt_default = true,
  -- list of plugins that should be taken from ~/projects
  -- this is NOT packer functionality!
  local_plugins = {
    folke = true,
    ["null-ls.nvim"] = false,
    ["nvim-lspconfig"] = false,
    -- ["nvim-treesitter"] = true,
  },
}

local function plugins(use)
  -- Packer can manage itself as an optional plugin
  use({ "wbthomason/packer.nvim" })
  use({
    "nathom/filetype.nvim",
    opt = false,
    config = function()
      require("config.filetype")
    end,
  })
  use({ "folke/workspace.nvim", module = "workspace" })
  use({ "stevearc/dressing.nvim", event = "BufReadPre" })
  use({
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require("notify")
    end,
  })
  -- LSP
  use({
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    wants = {
      "nvim-lsp-ts-utils",
      "null-ls.nvim",
      "lua-dev.nvim",
      -- "cmp-nvim-lsp",
      "nvim-lsp-installer",
    },
    config = function()
      require("config.lsp")
    end,
    requires = {
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/lua-dev.nvim",
      "williamboman/nvim-lsp-installer",
    },
  })
  use({
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    wants = "nvim-treesitter",
    module = "nvim-gps",
    config = function()
      require("nvim-gps").setup({ separator = " " })
    end,
  })

  use({
    "simrat39/rust-tools.nvim",
    module = "rust-tools",
  })

  use({ "kazhala/close-buffers.nvim", cmd = "BDelete" })

  use({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("config.compe")
    end,
    wants = { "LuaSnip" },
    requires = {
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require("config.snippets")
        end,
      },
      "rafamadriz/friendly-snippets",
      {
        module = "nvim-autopairs",
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
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc", "gbc" },
    config = function()
      require("config.comments")
    end,
  })

  use({ "JoosepAlviste/nvim-ts-context-commentstring", module = "ts_context_commentstring" })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "BufRead",
    requires = {
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
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
    opt = false,
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
  use({ "glepnir/dashboard-nvim", opt = false, config = [[require('config.dashboard')]] })

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
    config = function()
      require("config.telescope")
    end,
    cmd = { "Telescope" },
    module = "telescope",
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
  use({ "rlch/github-notifications.nvim", module = "github-notifications" })
  -- Statusline
  use({
    "nvim-lualine/lualine.nvim",
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
    requires = "godlygeek/tabular",
    ft = "markdown",
  })
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    cmd = { "MarkdownPreview" },
  })

  -- use { "tjdevries/train.nvim", cmd = { "TrainClear", "TrainTextObj", "TrainUpDown", "TrainWord" } }

  -- use({ "wfxr/minimap.vim", config = function()
  --   require("config.minimap")
  -- end })

  use({
    "phaazon/hop.nvim",
    keys = { "gh" },
    cmd = { "HopWord", "HopChar1" },
    config = function()
      require("util").nmap("gh", "<cmd>HopWord<CR>")
      -- require("util").nmap("s", "<cmd>HopChar1<CR>")
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup({})
    end,
  })

  use({
    "ggandor/lightspeed.nvim",
    keys = { "s", "S", "f", "F", "t", "T" },
    config = function()
      require("config.lightspeed")
    end,
  })

  use({
    "folke/trouble.nvim",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({
        auto_open = false,
        use_diagnostic_signs = true, -- en
      })
    end,
  })

  use({
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  })

  use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

  use({ "mbbill/undotree", cmd = "UndotreeToggle" })

  use({ "mjlbach/babelfish.nvim", module = "babelfish" })

  use({ "folke/twilight.nvim", module = "twilight" })
  use({
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup({
        plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } },
      })
    end,
  })

  use({
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
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
    module = "diffview",
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

  use("nanotee/luv-vimdocs")
  use({
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  })
end

return packer.setup(config, plugins)
