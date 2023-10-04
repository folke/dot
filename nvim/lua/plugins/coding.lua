return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = { ["*"] = true },
    },
  },
  -- {
  --   "huggingface/llm.nvim",
  --   cmd = "LLMToggleAutoSuggest",
  --   opts = {
  --     api_token = vim.env.HFCC_API_KEY,
  --     lsp = {
  --       bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
  --     },
  --     model = "bigcode/starcoder",
  --     query_params = {
  --       max_new_tokens = 200,
  --     },
  --   },
  --   init = function()
  --     vim.api.nvim_create_user_command("StarCoder", function()
  --       require("hfcc.completion").complete()
  --     end, {})
  --   end,
  -- },

  -- {
  --   "danymat/neogen",
  --   keys = {
  --     {
  --       "<leader>cc",
  --       function()
  --         require("neogen").generate({})
  --       end,
  --       desc = "Neogen Comment",
  --     },
  --   },
  --   opts = { snippet_engine = "luasnip" },
  -- },
  --
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  -- {
  --   "echasnovski/mini.bracketed",
  --   event = "BufReadPost",
  --   enabled = false,
  --   config = function()
  --     local bracketed = require("mini.bracketed")
  --     bracketed.setup({
  --       file = { suffix = "" },
  --       window = { suffix = "" },
  --       quickfix = { suffix = "" },
  --       yank = { suffix = "" },
  --       treesitter = { suffix = "n" },
  --     })
  --   end,
  -- },

  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = {},
  },

  {
    "nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    end,
  },
}
