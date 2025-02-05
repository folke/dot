return {
  -- { "ibhagwan/fzf-lua", cmd = "FzfLua" },
  -- {
  --   "echasnovski/mini.pick",
  --   event = "VeryLazy",
  --   cmd = "MiniPick",
  --   opts = {},
  -- },
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   cmd = "Telescope",
  --   opts = {},
  -- },
  {
    "sphamba/smear-cursor.nvim",
    enabled = false,
    cond = not (vim.env.KITTY_PID or vim.g.neovide),
  },
}
