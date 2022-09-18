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
    ["null-ls.nvim"] = false,
    ["nvim-lspconfig"] = false,
    -- ["nvim-treesitter"] = true,
  },
}

local function plugins(use)
  -- Packer can manage itself as an optional plugin
  use({ "wbthomason/packer.nvim" })

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
    config = function()
      require("config.lsp")
    end,
  })

  use({ "b0o/SchemaStore.nvim", module = "schemastore" })
  use({ "jose-elias-alvarez/typescript.nvim", module = "typescript" })
  use({ "jose-elias-alvarez/null-ls.nvim", module = "null-ls" })
  use({ "folke/lua-dev.nvim", module = "lua-dev" })
  use({
    "folke/settings.nvim",
    module = "nvim-settings",
    cmd = "Settings",
  })
  use({
    "j-hui/fidget.nvim",
    module = "fidget",
    config = function()
      require("fidget").setup({
        window = {
          relative = "editor",
        },
      })
      -- HACK: prevent error when exiting Neovim
      vim.api.nvim_create_autocmd("VimLeavePre", { command = [[silent! FidgetClose]] })
    end,
  })

  use({
    "monaqa/dial.nvim",
    module = "dial",
    keys = { "<C-a>", "<C-x>" },
    config = function()
      require("config.dial")
    end,
  })

  use({
    "williamboman/mason.nvim",
    module = "mason",
    opt = true,
  })
  use({
    "williamboman/mason-lspconfig.nvim",
    module = "mason-lspconfig",
    opt = true,
  })
  use({
    "SmiteshP/nvim-navic",
    module = "nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " " })
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
    module = "cmp",
    config = function()
      require("config.cmp")
    end,
    requires = {
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
  })

  use({
    "windwp/nvim-autopairs",
    module = "nvim-autopairs",
    config = function()
      require("config.autopairs")
    end,
  })

  use({
    "L3MON4D3/LuaSnip",
    module = "luasnip",
    config = function()
      require("config.snippets")
    end,
    requires = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  })

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
  })

  use({
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc", "gbc" },
    config = function()
      require("Comment").setup({})
    end,
  })

  use({
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    config = function()
      require("config.tree")
    end,
  })

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
    requires = "nvim-treesitter/nvim-treesitter",
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "BufRead",
    module = "nvim-treesitter",
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    config = [[require('config.treesitter')]],
  })

  use({ "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" })

  -- Theme: color schemes
  use({
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

  use({
    "windwp/nvim-spectre",
    module = "spectre",
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
    requires = {
      { "nvim-telescope/telescope-file-browser.nvim", module = "telescope._extensions.file_browser" },
      { "nvim-telescope/telescope-z.nvim", module = "telescope._extensions.z" },
      { "nvim-telescope/telescope-project.nvim", module = "telescope._extensions.project" },
      { "nvim-telescope/telescope-symbols.nvim", module = "telescope._extensions.symbols" },
      { "nvim-telescope/telescope-fzf-native.nvim", module = "telescope._extensions.fzf", run = "make" },
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
    config = function()
      require("config.bufferline")
    end,
  })

  -- Terminal
  use({
    "akinsho/nvim-toggleterm.lua",
    keys = "<C-/>",
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

  use({
    "michaelb/sniprun",
    run = "bash ./install.sh",
    cmd = "SnipRun",
    keys = { "<leader>r" },
    module = "sniprun",
    config = function()
      require("config.sniprun")
    end,
  })

  -- Git Gutter
  use({
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("config.gitsigns")
    end,
  })

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
  })

  use({
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("config.colorizer")
    end,
  })

  use({ "kevinhwang91/promise-async", module = "promise" })
  use({
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    config = function()
      require("config.folds")
    end,
  })

  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    cmd = { "MarkdownPreview" },
  })

  use({
    "phaazon/hop.nvim",
    cmd = "HopWord",
    module = "hop",
    keys = { "gh", "f", "F", "t", "T" },
    config = function()
      require("config.jump")
    end,
  })

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

  use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

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
    config = function()
      require("illuminate").configure({ delay = 200 })
    end,
  })

  use({
    "nvim-neorg/neorg",
    module = "neorg",
    -- tag = "latest",
    ft = "norg",
    config = function()
      require("config.neorg")
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
