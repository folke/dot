return require("packer").startup(function(use)
  -- Packer can manage itself as an optional plugin
  use({ "wbthomason/packer.nvim", opt = true })

  -- LSP
  use({
    "neovim/nvim-lspconfig",
    config = function() require("config.lsp") end,
    requires = {
      "kabouzeid/nvim-lspinstall",
      { "glepnir/lspsaga.nvim", config = function() require("config.lsp.saga") end },
      { "onsails/lspkind-nvim", config = function() require("lspkind").init() end }
    }
  })
  use({
    "hrsh7th/nvim-compe",
    config = function() require("config.compe") end,
    requires = {
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
      { "windwp/nvim-autopairs", config = function() require("config.autopairs") end }
    }
  })

  use {
    "b3nj5m1n/kommentary",
    config = function() require("config.comments") end,
    requires = "JoosepAlviste/nvim-ts-context-commentstring"
  }

  -- Theme: color schemes
  use({ "tjdevries/colorbuddy.nvim" })
  use({
    "wadackel/vim-dogrun",
    "marko-cerovac/material.nvim",
    "sainnhe/edge",
    -- "norcalli/nvim-base16.lua",
    "RRethy/nvim-base16",
    "glepnir/zephyr-nvim",
    -- "bluz71/vim-nightfly-guicolors",
    -- "sainnhe/sonokai",
    "Th3Whit3Wolf/onebuddy",
    -- "christianchiarulli/nvcode-color-schemes.vim",
    "Th3Whit3Wolf/one-nvim"
  })

  -- Theme: icons
  use({ "yamatsum/nvim-web-nonicons", requires = { "kyazdani42/nvim-web-devicons" } })

  -- Dashboard
  use({ "glepnir/dashboard-nvim", config = [[require('config.dashboard')]] })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = [[require('config.treesitter')]]
  })

  use({ "kyazdani42/nvim-tree.lua", config = function() require("config.tree") end })

  use {
    "AckslD/nvim-whichkey-setup.lua",
    requires = { "liuchengxu/vim-which-key" },
    config = [[require('config.keys')]]
  }

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    config = function() require("config.telescope") end,
    requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" }
  })

  -- Indent Guides and rainbow brackets
  use({
    "lukas-reineke/indent-blankline.nvim",
    requires = "nvim-treesitter/nvim-treesitter",
    branch = "lua",
    config = function() require("config.blankline") end
  })
  use({
    "p00f/nvim-ts-rainbow",
    config = function() require("nvim-treesitter.configs").setup({ rainbow = { enable = true } }) end
  })

  -- Tabs
  use({
    "akinsho/nvim-bufferline.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = { show_close_icon = false, always_show_bufferline = false }
      })
    end
  })

  -- Terminal
  use { "akinsho/nvim-toggleterm.lua", config = function() require("config.terminal") end }

  -- Smooth Scrolling
  use { "karb94/neoscroll.nvim", config = function() require("config.scroll") end }
  use { "edluffy/specs.nvim", config = function() require("config.specs") end }

  -- Git Gutter
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end
  })
  use {
    "kdheepak/lazygit.nvim",
    config = function() vim.g.lazygit_floating_window_use_plenary = 0 end
  }

  -- Statusline
  use({
    "hoob3rt/lualine.nvim",
    config = [[require('config.lualine')]],
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  })

  use({ "norcalli/nvim-colorizer.lua", config = function() require("config.colorizer") end })

  use "npxbr/glow.nvim"

  -- use {
  --   "vim-pandoc/vim-pandoc",
  --   requires = "vim-pandoc/vim-pandoc-syntax",
  --   config = function() require("config.markdown") end
  -- }

  use {
    "plasticboy/vim-markdown",
    requires = "godlygeek/tabular",
    config = function() require("config.markdown") end
  }

  -- use { "SidOfc/mkdx", config = function() require("config.markdown") end }

  -- Training Wheels for text objects :-)
  use "tjdevries/train.nvim"
end)
