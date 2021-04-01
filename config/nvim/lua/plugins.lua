return require("packer").startup(function(use)
  -- Packer can manage itself as an optional plugin
  use({ "wbthomason/packer.nvim", opt = true })

  -- LSP
  use({ "neovim/nvim-lspconfig", config = function() require("config.lsp") end })
  use({ "hrsh7th/nvim-compe", config = function() require("config.compe") end })

  -- Theme: color schemes
  use({ "tjdevries/colorbuddy.nvim" })
  use({
    "wadackel/vim-dogrun",
    "marko-cerovac/material.nvim",
    "sainnhe/edge",
    "bluz71/vim-nightfly-guicolors",
    "sainnhe/sonokai"
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

  use({ "kyazdani42/nvim-tree.lua" })

  use({ "liuchengxu/vim-which-key", config = [[require('config.keys')]] })

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } }
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
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

  -- Git Gutter
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end
  })

  -- Statusline
  use({
    "hoob3rt/lualine.nvim",
    config = [[require('config.lualine')]],
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  })
end)
