return {
  { "mini.animate", enabled = false },
  { "indent-blankline.nvim", enabled = false },

  -- {
  --   "foobar",
  --   event = "VeryLazy",
  --   virtual = true,
  --   config = function()
  --     vim.notify("foo")
  --   end,
  -- },
  -- { "sindrets/diffview.nvim", opts = {}, lazy = false },
  -- { "folke/zen-mode.nvim", opts = {}, lazy = false },
  -- { "conform.nvim", dev = true },
  -- { "smear-cursor.nvim", dev = true },
  -- { "blink.cmp", dev = true },
  {
    "sphamba/smear-cursor.nvim",
    enabled = false,
    cond = not (vim.env.KITTY_PID or vim.g.neovide),
  },
  -- {
  --   "mini.animate",
  --   opts = { cursor = { enable = not (vim.env.KITTY_PID or vim.g.neovide) } },
  -- },
}
