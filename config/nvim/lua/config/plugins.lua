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
  auto_reload_compiled = false,
  -- list of plugins that should be taken from ~/projects
  -- this is NOT packer functionality!
  local_plugins = {
    folke = true,
    -- ["folke/neodev.nvim"] = false,
    -- ["null-ls.nvim"] = true,
    -- ["nvim-lspconfig"] = true,
    -- ["nvim-notify"] = true,
    -- ["yanky.nvim"] = true,
    -- ["nvim-treesitter"] = true,
  },
}

local function plugins(use, plugin)
  -- Packer can manage itself as an optional plugin
  use({ "wbthomason/packer.nvim" })
  plugin("folke/noice.nvim")

  use({
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    module = "inc_rename",
    config = function()
      require("inc_rename").setup()
    end,
  })

  use({
    "folke/paint.nvim",
    event = "BufReadPre",
    config = function()
      require("paint").setup()
    end,
  })
  plugin("toppair/peek.nvim")

  plugin("b0o/incline.nvim")
  plugin("gbprod/yanky.nvim")

  use({ "stevearc/dressing.nvim", event = "User PackerDefered" })

  plugin("rcarriga/nvim-notify")

  -- LSP
  use({ "neovim/nvim-lspconfig", plugin = "lsp" })

  use({ "b0o/SchemaStore.nvim", module = "schemastore" })
  use({ "jose-elias-alvarez/typescript.nvim", module = "typescript" })

  plugin("jose-elias-alvarez/null-ls.nvim")

  use({ "folke/neodev.nvim", module = "neodev" })
  use({
    "folke/neoconf.nvim",
    module = "neoconf",
    cmd = "Neoconf",
  })

  plugin("anuvyklack/windows.nvim")

  plugin("monaqa/dial.nvim")

  plugin("williamboman/mason.nvim")
  use({
    "williamboman/mason-lspconfig.nvim",
    module = "mason-lspconfig",
  })

  use({
    "SmiteshP/nvim-navic",
    module = "nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
    end,
  })

  use({
    "ThePrimeagen/refactoring.nvim",
    module = "refactoring",
    config = function()
      require("refactoring").setup({})
    end,
    setup = function()
      -- prompt for a refactor to apply when the remap is triggered
      vim.keymap.set("v", "<leader>cr", function()
        require("refactoring").select_refactor()
      end, { noremap = true, silent = true, expr = false })
    end,
  })

  plugin("simrat39/rust-tools.nvim")

  plugin("petertriho/nvim-scrollbar")

  plugin("hrsh7th/nvim-cmp")

  plugin("windwp/nvim-autopairs")

  plugin("L3MON4D3/LuaSnip")

  use({
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = function()
      require("nvim-surround").setup({})
    end,
  })

  use({
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline" },
    config = function()
      require("symbols-outline").setup()
    end,
    setup = function()
      vim.keymap.set("n", "<leader>cs", "<cmd>SymbolsOutline<cr>", { desc = "Symbols Outline" })
    end,
  })

  plugin("numToStr/Comment.nvim")

  plugin("nvim-neo-tree/neo-tree.nvim")

  use({
    "MunifTanjim/nui.nvim",
    module = "nui",
  })

  use({
    "danymat/neogen",
    module = "neogen",
    config = function()
      require("neogen").setup({ snippet_engine = "luasnip" })
    end,
  })

  plugin("nvim-treesitter/nvim-treesitter")

  use({ "nvim-treesitter/playground", cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" } })

  use({
    "m-demare/hlargs.nvim",
    event = "User PackerDefered",
    config = function()
      require("hlargs").setup({
        color = require("tokyonight.colors").setup().yellow,
        excluded_argnames = {
          usages = {
            lua = { "self", "use" },
          },
        },
      })
    end,
  })

  -- Theme: color schemes
  plugin("folke/tokyonight.nvim")

  -- Theme: icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })

  -- Dashboard
  plugin("glepnir/dashboard-nvim")

  use({
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
      require("terminal").setup()
    end,
  })
  use({ "nvim-lua/plenary.nvim", module = "plenary" })

  use({
    "windwp/nvim-spectre",
    module = "spectre",
  })

  -- Fuzzy finder
  plugin("nvim-telescope/telescope.nvim")

  plugin("lukas-reineke/indent-blankline.nvim")
  plugin("akinsho/nvim-bufferline.lua")

  -- Terminal
  plugin("akinsho/nvim-toggleterm.lua")

  -- Smooth Scrolling
  plugin("karb94/neoscroll.nvim")

  plugin("edluffy/specs.nvim")

  plugin("echasnovski/mini.nvim")

  plugin("lewis6991/gitsigns.nvim")
  plugin("TimUntersberger/neogit")

  plugin("mfussenegger/nvim-dap")

  use({ "rlch/github-notifications.nvim", module = "github-notifications" })
  -- Statusline
  plugin("nvim-lualine/lualine.nvim")

  plugin("NvChad/nvim-colorizer.lua")

  -- plugin("kevinhwang91/nvim-ufo")

  plugin("phaazon/hop.nvim")

  use({
    "folke/trouble.nvim",
    event = "BufReadPre",
    module = "trouble",
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

  use({
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  })

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

  plugin("pwntester/octo.nvim")

  plugin("folke/todo-comments.nvim")

  use({
    "folke/which-key.nvim",
    module = "which-key",
  })

  plugin("sindrets/diffview.nvim")

  plugin("RRethy/vim-illuminate")

  plugin("nvim-neorg/neorg")

  use({
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  })
end

return packer.setup(config, plugins)
