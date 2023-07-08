return {
  { "nvim-telescope/telescope.nvim", dev = true },
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
  { "3rd/image.nvim", opts = {}, ft = "markdown", lazy = false, enabled = true },
  {
    "folke/flash.nvim",
    enabled = true,
    build = function() end,
    init = function()
      -- vim.opt.keymap = "emoji"
    end,
    ---@type Flash.Config
    opts = {
      -- labels = "#abcdef",
      label = {
        -- format = function(opts)
        --   return { { opts.match.label:upper(), opts.hl_group } }
        -- end,
      },
      modes = {
        -- treesitter = {
        --   label = {
        --     rainbow = { enabled = true },
        --   },
        -- },
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
