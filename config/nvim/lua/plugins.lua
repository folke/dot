local config = {
  profile = {
    enable = true,
    threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
  }
}

return require("packer").startup({
  function(use)
    -- Packer can manage itself as an optional plugin
    use({ "wbthomason/packer.nvim", opt = true })

    -- LSP
    use({
      "neovim/nvim-lspconfig",
      opt = true,
      event = "BufReadPre",
      wants = "nvim-lspinstall",
      config = function() require("config.lsp") end,
      requires = {
        "kabouzeid/nvim-lspinstall",
        { "jose-elias-alvarez/nvim-lsp-ts-utils", branch = "develop" },
        {
          "glepnir/lspsaga.nvim",
          event = "BufReadPre",
          config = function() require("config.lsp.saga") end
        },
        {
          "onsails/lspkind-nvim",
          event = "InsertEnter",
          config = function() require("lspkind").init() end
        }
      }
    })
    use({
      "hrsh7th/nvim-compe",
      event = "InsertEnter",
      opt = true,
      config = function() require("config.compe") end,
      requires = {
        "hrsh7th/vim-vsnip",
        "hrsh7th/vim-vsnip-integ",
        "rafamadriz/friendly-snippets",
        { "windwp/nvim-autopairs", config = function() require("config.autopairs") end }
      }
    })
    use {
      "liuchengxu/vista.vim",
      cmd = { "Vista" },
      config = function() vim.g.vista_default_executive = "nvim_lsp" end
    }

    use {
      "b3nj5m1n/kommentary",
      opt = true,
      wants = "nvim-ts-context-commentstring",
      keys = { "<C-_>", "gc", "gcc" },
      config = function() require("config.comments") end,
      requires = "JoosepAlviste/nvim-ts-context-commentstring"
    }

    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      requires = { "~/projects/playground" },
      config = [[require('config.treesitter')]]
    })

    -- Theme: color schemes
    use({
      -- { "olimorris/onedark.nvim", requires = "rktjmp/lush.nvim" },
      "wadackel/vim-dogrun",
      -- { "npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim" },
      "bluz71/vim-nightfly-guicolors",
      { "marko-cerovac/material.nvim" },
      -- "sainnhe/edge",
      { "embark-theme/vim", as = "embark" },
      -- "norcalli/nvim-base16.lua",
      -- "RRethy/nvim-base16",
      -- "novakne/kosmikoa.nvim",
      "glepnir/zephyr-nvim",
      -- "ghifarit53/tokyonight-vim"
      "sainnhe/sonokai",
      "morhetz/gruvbox",
      "arcticicestudio/nord-vim",
      -- "drewtempelmeyer/palenight.vim",
      -- "Th3Whit3Wolf/onebuddy",
      -- "christianchiarulli/nvcode-color-schemes.vim",
      -- "Th3Whit3Wolf/one-nvim"
      "~/projects/tokyonight.nvim"
    })

    -- Theme: icons
    use({
      "kyazdani42/nvim-web-devicons",
      config = function() require"nvim-web-devicons".setup { default = true } end
    })

    -- Dashboard
    use({ "glepnir/dashboard-nvim", config = [[require('config.dashboard')]] })

    use { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" }

    use {
      "windwp/nvim-spectre",
      opt = true,
      module = "spectre",
      wants = { "plenary.nvim", "popup.nvim" },
      requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" }
    }

    use({
      "kyazdani42/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      config = function() require("config.tree") end
    })

    use "dag/vim-fish"

    -- Fuzzy finder
    use({
      "nvim-telescope/telescope.nvim",
      opt = true,
      config = function() require("config.telescope") end,
      cmd = { "Telescope" },
      keys = { "<leader><space>", "<leader>fz", "<leader>pp" },
      wants = {
        "plenary.nvim",
        "popup.nvim",
        "telescope-z.nvim",
        -- "telescope-frecency.nvim",
        "telescope-project.nvim"
      },
      requires = {
        "nvim-telescope/telescope-z.nvim",
        "nvim-telescope/telescope-project.nvim",
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim"
        -- { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sql.nvim" }
      }
    })

    -- Indent Guides and rainbow brackets
    use({
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      branch = "lua",
      config = function() require("config.blankline") end
    })
    use({
      "p00f/nvim-ts-rainbow",
      event = "BufReadPre",
      config = function()
        require("nvim-treesitter.configs").setup({ rainbow = { enable = true } })
      end
    })

    -- Tabs
    use({
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      requires = "kyazdani42/nvim-web-devicons",
      config = function() require("config.bufferline") end
    })

    -- Terminal
    use {
      "akinsho/nvim-toggleterm.lua",
      keys = "<M-`>",
      module = "folke.util",
      config = function() require("config.terminal") end
    }

    -- Smooth Scrolling
    use { "karb94/neoscroll.nvim", config = function() require("config.scroll") end }
    use { "edluffy/specs.nvim", config = function() require("config.specs") end }
    use { "Xuyuanp/scrollbar.nvim", config = function() require("config.scrollbar") end }

    -- Git Gutter
    use({
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      wants = "plenary.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function() require("config.gitsigns") end
    })
    use {
      "kdheepak/lazygit.nvim",
      cmd = "LazyGit",
      config = function() vim.g.lazygit_floating_window_use_plenary = 0 end
    }
    use { "TimUntersberger/neogit", cmd = "Neogit", config = function() require("config.neogit") end }

    -- Statusline
    use({
      "hoob3rt/lualine.nvim",
      config = [[require('config.lualine')]],
      requires = { "kyazdani42/nvim-web-devicons", opt = true }
    })

    use({
      "norcalli/nvim-colorizer.lua",
      event = "BufReadPre",
      config = function() require("config.colorizer") end
    })

    use { "npxbr/glow.nvim", cmd = "Glow" }

    -- use {
    --   "vim-pandoc/vim-pandoc",
    --   requires = "vim-pandoc/vim-pandoc-syntax",
    --   config = function() require("config.markdown") end
    -- }

    use {
      "plasticboy/vim-markdown",
      opt = true,
      requires = "godlygeek/tabular",
      ft = "markdown",
      config = function() require("config.markdown") end
    }
    use {
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
      ft = { "markdown" },
      cmd = "MarkdownPreview"
    }

    -- use { "tjdevries/train.nvim", cmd = { "TrainClear", "TrainTextObj", "TrainUpDown", "TrainWord" } }

    -- use { "wfxr/minimap.vim", config = function() require("config.minimap") end }

    use {
      "phaazon/hop.nvim",
      keys = "gh",
      config = function()
        require("util").nmap("gh", ":HopWord<CR>")
        -- you can configure Hop the way you like here; see :h hop-config
        require"hop".setup {}
      end
    }

    use {
      "~/projects/lsp-trouble.nvim",
      event = "BufReadPre",
      requires = "kyazdani42/nvim-web-devicons",
      cmd = "LspTroubleToggle",
      config = function() require"trouble".setup { auto_open = false } end
    }

    use { "tpope/vim-obsession", setup = function() require("config.session") end }

    use { "dstein64/vim-startuptime", cmd = "StartupTime" }

    use { "mbbill/undotree", cmd = "UndotreeToggle" }

    -- use { "mg979/vim-visual-multi", keys = "<C-n>" }

    -- use { "mjlbach/babelfish.nvim", module = "babelfish" }

    use { "~/projects/lsp-colors.nvim" }
    use { "~/projects/which-key.nvim", config = function() require("config.keys") end }
  end,
  config = config
})
