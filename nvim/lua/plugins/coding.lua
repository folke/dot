return {
  {
    "folke/ts-comments.nvim",
    opts = {
      langs = {
        dts = "// %s",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = {
      filetypes = { ["*"] = true },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    optional = true,
    opts = { show_help = false },
  },
  {
    "echasnovski/mini.align",
    opts = {},
    keys = {
      { "ga", mode = { "n", "v" } },
      { "gA", mode = { "n", "v" } },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   opts = {
  --     adapters = {
  --       -- ["neotest-plenary"] = { min_init = "./tests/init.lua" },
  --       -- "neotest-vitest",
  --       -- ["neotest-busted"] = {
  --       --   busted_command = "./tests/minit.lua",
  --       --   busted_args = { "--busted" },
  --       -- },
  --     },
  --   },
  -- },
  { "echasnovski/mini.test" },

  { "folke/github" },
  -- { "justinsgithub/wezterm-types", lazy = true },
  { "LuaCATS/luassert", name = "luassert-types", lazy = true },
  { "LuaCATS/busted", name = "busted-types", lazy = true },
  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      opts.debug = true
      opts.runtime = "~/projects/neovim/runtime"
      vim.list_extend(opts.library, {
        -- { path = "wezterm-types", mods = { "wezterm" } },
        { path = "luassert-types/library", words = { "assert" } },
        { path = "busted-types/library", words = { "describe" } },
      })
    end,
  },
}
