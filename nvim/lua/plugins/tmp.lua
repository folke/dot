-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = vim.api.nvim_create_augroup("group", { clear = true }),
--   callback = function(ev)
--     vim.defer_fn(function()
--       dd("loading")
--       require("lazy.core.plugin").load()
--       -- local plugins = require("lazy.core.config").plugins["lazy.nvim"]
--       -- local p = require("lazy.core.config").plugins
--     end, 2000)
--   end,
-- })

return {
  -- { "gvvaughan/lyaml" },
  { "folke/noice.nvim", event = "CmdLineEnter" },
  -- { "stevearc/dressing.nvim", enabled = false },
  -- { "folke/noice.nvim", opts = { debug = true } },
  -- { "neo-tree.nvim", enabled = false },
  {
    "ibhagwan/fzf-lua",
    dev = false,
    opts = {
      winopts = {
        -- border = "none",
      },
    },
  },
  -- {
  --   "nvim-neorg/neorg",
  --   enabled = false,
  --   cmd = "Neorg",
  --   opts = {},
  -- },
  {
    "folke/edgy.nvim",
    enabled = true,
    opts = {
      animate = { enabled = true },
    },
  },
  { "justinsgithub/wezterm-types", lazy = true },
  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      opts.debug = true
      opts.runtime = "~/projects/neovim/runtime"
      vim.list_extend(opts.library, {
        { path = "wezterm-types", mods = { "wezterm" } },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = { show_help = false },
  },
  {

    "folke/trouble.nvim",
    -- build = function()
    --   for i = 1, 5 do
    --     require("lazy.util").sleep(1000)
    --     coroutine.yield("step" .. i)
    --   end
    -- end,
    opts = {
      -- debug = true,
      -- preview = {
      --   type = "split",
      --   relative = "win",
      --   position = "right",
      --   size = 0.5,
      -- },
    },
  },
  {
    "fei6409/log-highlight.nvim",
    event = "BufRead *.log",
    opts = {},
  },
  {
    "t-troebst/perfanno.nvim",
    opts = function()
      local util = require("perfanno.util")
      local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
      local bg = string.format("#%06x", hl.bg)
      local fg = "#dc2626"
      return {
        line_highlights = util.make_bg_highlights(bg, fg, 10),
        vt_highlight = util.make_fg_highlight(fg),
      }
    end,
    cmd = "PerfLuaProfileStart",
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slope",
      },
    },
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
    "folke/flash.nvim",
    ---@module 'flash'
    ---@type Flash.Config
    opts = {
      -- labels = "#abcdef",
      modes = {
        -- char = { jump_labels = false },
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
}
