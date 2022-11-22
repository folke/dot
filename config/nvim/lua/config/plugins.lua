return {
  "folke/noice.nvim",
  "glacambre/firenvim",
  "toppair/peek.nvim",
  "b0o/incline.nvim",
  "gbprod/yanky.nvim",
  "rcarriga/nvim-notify",
  "folke/tokyonight.nvim",
  "nvim-lualine/lualine.nvim",
  "NvChad/nvim-colorizer.lua",
  "kevinhwang91/nvim-ufo",
  "phaazon/hop.nvim",
  "ggandor/leap.nvim",
  "pwntester/octo.nvim",
  "folke/todo-comments.nvim",
  "sindrets/diffview.nvim",
  "RRethy/vim-illuminate",
  "nvim-neorg/neorg",
  "jose-elias-alvarez/null-ls.nvim",
  "anuvyklack/windows.nvim",
  "monaqa/dial.nvim",
  "williamboman/mason.nvim",
  "simrat39/rust-tools.nvim",
  "petertriho/nvim-scrollbar",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  "nvim-neo-tree/neo-tree.nvim",
  "nvim-telescope/telescope.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "akinsho/nvim-bufferline.lua",
  "akinsho/nvim-toggleterm.lua",
  "karb94/neoscroll.nvim",
  "edluffy/specs.nvim",
  "echasnovski/mini.nvim",
  "lewis6991/gitsigns.nvim",
  "TimUntersberger/neogit",
  "mfussenegger/nvim-dap",
  "nvim-treesitter/nvim-treesitter",

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    module = "inc_rename",
    config = function()
      require("inc_rename").setup()
    end,
  },
  -- plugin("zbirenbaum/copilot.lua")

  {
    "folke/styler.nvim",
    opt = false,
    event = "User VeryLazy",
    config = function()
      -- require("styler").setup({
      --   themes = {
      --     markdown = { colorscheme = "tokyonight-storm" },
      --     help = { colorscheme = "gruvbox", background = "dark" },
      --     -- noice = { colorscheme = "gruvbox", background = "dark" },
      --   },
      -- })
    end,
  },

  {
    "folke/drop.nvim",
    event = "VimEnter",
    config = function()
      math.randomseed(os.time())
      local theme = ({ "stars", "snow" })[math.random(1, 2)]
      require("drop").setup({ theme = theme })
    end,
  },

  {
    opt = false,
    "ellisonleao/gruvbox.nvim",
  },

  {
    "folke/paint.nvim",
    event = "BufReadPre",
    config = function()
      require("paint").setup()
    end,
  },

  { "stevearc/dressing.nvim", event = "User VeryLazy" },

  -- LSP
  { "neovim/nvim-lspconfig", name = "lsp" },

  { "b0o/SchemaStore.nvim", module = "schemastore" },
  { "jose-elias-alvarez/typescript.nvim", module = "typescript" },

  { "folke/neodev.nvim", module = "neodev" },
  {
    "folke/neoconf.nvim",
    module = "neoconf",
    cmd = "Neoconf",
  },

  {
    "williamboman/mason-lspconfig.nvim",
    module = "mason-lspconfig",
  },

  {
    "SmiteshP/nvim-navic",
    module = "nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    module = "refactoring",
    config = function()
      require("refactoring").setup({})
    end,
    setup = function()
      -- prompt for a refactor to apply when the remap is triggered
      vim.keymap.set("v", "<leader>r", function()
        require("refactoring").select_refactor()
      end, { noremap = true, silent = true, expr = false })
    end,
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline" },
    config = function()
      require("symbols-outline").setup()
    end,
    setup = function()
      vim.keymap.set("n", "<leader>cs", "<cmd>SymbolsOutline<cr>", { desc = "Symbols Outline" })
    end,
  },

  {
    "MunifTanjim/nui.nvim",
    module = "nui",
  },

  {
    "danymat/neogen",
    module = "neogen",
    config = function()
      require("neogen").setup({ snippet_engine = "luasnip" })
    end,
  },

  { "nvim-treesitter/playground", cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" } },

  {
    "m-demare/hlargs.nvim",
    event = "User VeryLazy",
    config = function()
      require("hlargs").setup({
        excluded_argnames = {
          usages = {
            lua = { "self", "use" },
          },
        },
      })
    end,
  },

  -- Theme: icons
  {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },

  {
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
      require("terminal").setup()
    end,
  },
  { "nvim-lua/plenary.nvim", module = "plenary" },

  {
    "windwp/nvim-spectre",
    module = "spectre",
  },

  { "rlch/github-notifications.nvim", module = "github-notifications" },
  -- Statusline

  {
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
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup({
        options = { "buffers", "curdir", "tabpages", "winsize", "help" },
      })
    end,
  },

  {
    "cshuaimin/ssr.nvim",
    module = "ssr",
    -- Calling setup is optional.
    init = function()
      vim.keymap.set({ "n", "x" }, "<leader>cR", function()
        require("ssr").open()
      end, { desc = "Structural Replace" })
    end,
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = function()
      require("treesitter-context").setup()
    end,
  },

  { "folke/twilight.nvim", module = "twilight" },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup({
        plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    module = "which-key",
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
}
