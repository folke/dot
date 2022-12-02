return {

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",

    config = function()
      require("inc_rename").setup()
    end,
  },
  {
    "folke/styler.nvim",
    event = "User VeryLazy",
    config = function()
      require("styler").setup({
        themes = {
          markdown = { colorscheme = "tokyonight-storm" },
          help = { colorscheme = "gruvbox", background = "dark" },
          -- noice = { colorscheme = "gruvbox", background = "dark" },
        },
      })
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
    lazy = false,
    "ellisonleao/gruvbox.nvim",
  },

  {
    "folke/paint.nvim",
    event = "BufReadPre",
    config = function()
      require("paint").setup({
        highlights = {
          {
            filter = { filetype = "lua" },
            pattern = "%s*%-%-%-%s*(@%w+)",
            hl = "Constant",
          },
          {
            filter = { filetype = "lua" },
            pattern = "%s*%-%-%[%[(@%w+)",
            hl = "Constant",
          },
          {
            filter = { filetype = "lua" },
            pattern = "%s*%-%-%-%s*@field%s+(%S+)",
            hl = "@field",
          },
          {
            filter = { filetype = "lua" },
            pattern = "%s*%-%-%-%s*@class%s+(%S+)",
            hl = "@variable.builtin",
          },
          {
            filter = { filetype = "lua" },
            pattern = "%s*%-%-%-%s*@alias%s+(%S+)",
            hl = "@keyword",
          },
          {
            filter = { filetype = "lua" },
            pattern = "%s*%-%-%-%s*@param%s+(%S+)",
            hl = "@parameter",
          },
        },
      })
    end,
  },

  { "stevearc/dressing.nvim", event = "User VeryLazy" },

  -- LSP

  { "b0o/SchemaStore.nvim" },
  { "jose-elias-alvarez/typescript.nvim" },

  { "folke/neodev.nvim" },
  {
    "folke/neoconf.nvim",

    cmd = "Neoconf",
  },

  {
    "williamboman/mason-lspconfig.nvim",
  },

  {
    "SmiteshP/nvim-navic",

    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",

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
  },

  {
    "danymat/neogen",

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
  { "nvim-lua/plenary.nvim" },

  {
    "windwp/nvim-spectre",
  },

  { "rlch/github-notifications.nvim" },
  -- Statusline

  {
    "folke/trouble.nvim",

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

    config = function()
      require("persistence").setup({
        options = { "buffers", "curdir", "tabpages", "winsize", "help" },
      })
    end,
  },
  {
    "Wansmer/treesj",
    keys = "J",
    config = function()
      require("treesj").setup({ use_default_keymaps = false })
      vim.keymap.set("n", "J", "<cmd>TSJToggle<cr>")
    end,
  },
  {
    "cshuaimin/ssr.nvim",

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

  { "folke/twilight.nvim" },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup({
        plugins = {
          gitsigns = true,
          tmux = true,
          kitty = { enabled = false, font = "+2" },
        },
      })
    end,
  },

  {
    "folke/which-key.nvim",
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
}
