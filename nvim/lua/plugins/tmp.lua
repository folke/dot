return {
  {
    "AckslD/muren.nvim",
    opts = {
      patterns_width = 60,
      patterns_height = 20,
      options_width = 40,
      preview_height = 24,
    },
    cmd = "MurenToggle",
  },
  {
    "folke/flash.nvim",
    enabled = true,
    ---@type Flash.Config
    opts = {
      label = {
        format = function(opts)
          return { { opts.match.label:upper(), opts.hl_group } }
        end,
      },
      modes = {
        treesitter_search = {
          label = {
            rainbow = { enabled = true },
            -- format = function(opts)
            --   local label = opts.match.label
            --   if opts.after then
            --     label = label .. ">"
            --   else
            --     label = "<" .. label
            --   end
            --   return { { label, opts.hl_group } }
            -- end,
          },
        },
      },
      -- search = { mode = "fuzzy" },
      -- labels = "😅😀🏇🐎🐴🐵🐒",
    },
  },
  -- { "rlane/pounce.nvim", opts = {}, cmd = "Pounce" },
  -- { "echasnovski/mini.jump", lazy = false, opts = {} },
}
