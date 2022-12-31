return {
  "b0o/SchemaStore.nvim",
  "jose-elias-alvarez/typescript.nvim",
  "MunifTanjim/nui.nvim",
  "williamboman/mason-lspconfig.nvim",
  "nvim-lua/plenary.nvim",
  "windwp/nvim-spectre",
  "folke/twilight.nvim",
  "folke/which-key.nvim",

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  {
    "folke/styler.nvim",
    event = "VeryLazy",
    config = {
      themes = {
        markdown = { colorscheme = "tokyonight-storm" },
        help = { colorscheme = "oxocarbon", background = "dark" },
        -- noice = { colorscheme = "gruvbox", background = "dark" },
      },
    },
  },

  {
    "folke/drop.nvim",
    event = "VimEnter",
    enabled = true,
    config = function()
      math.randomseed(os.time())
      local theme = ({ "stars", "snow", "xmas" })[math.random(1, 3)]
      require("drop").setup({ theme = theme })
    end,
  },

  { "shaunsingh/oxocarbon.nvim", enabled = true },

  { "ellisonleao/gruvbox.nvim" },

  {
    "folke/paint.nvim",
    enabled = false,
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

  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- LSP

  {
    "SmiteshP/nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    config = {},
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    config = { snippet_engine = "luasnip" },
  },

  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    enabled = false,
    config = {
      excluded_argnames = {
        usages = {
          lua = { "self", "use" },
        },
      },
    },
  },

  -- Theme: icons
  {
    "nvim-tree/nvim-web-devicons",
    config = { default = true },
  },

  {
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = true,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = {
      auto_open = false,
      use_diagnostic_signs = true, -- en
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
  },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>" },
    },
    config = { use_default_keymaps = false },
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>cR",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
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
    config = true,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
}
