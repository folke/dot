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
    opts = {
      filetypes = { ["*"] = true },
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
  -- { "nvim-neotest/neotest-plenary" },
  -- { "marilari88/neotest-vitest" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        -- ["neotest-plenary"] = { min_init = "./tests/init.lua" },
        -- "neotest-vitest",
        -- ["neotest-busted"] = {
        --   busted_command = "./tests/minit.lua",
        --   busted_args = { "--busted" },
        -- },
      },
    },
  },
}
