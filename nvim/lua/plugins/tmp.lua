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
vim.env.FZF_DEFAULT_OPTS = ""

vim.schedule(function() end)

return {
  { "echasnovski/mini.test" },
  {
    "folke/which-key.nvim",
    enabled = true,
    opts = {
      preset = "helix",
      debug = false,
      win = {
        -- padding = { 0, 1 },
        -- border = "single",
        -- height = { max = 5 },
      },
      spec = {},
    },
  },
  {
    "OXY2DEV/markview.nvim",
    enabled = true,
    opts = {
      checkboxes = { enable = false },
      links = {
        inline_links = {
          hl = "@markup.link.label.markown_inline",
          icon = " ",
          icon_hl = "@markup.link",
        },
        images = {
          hl = "@markup.link.label.markown_inline",
          icon = " ",
          icon_hl = "@markup.link",
        },
      },
      code_blocks = {
        style = "language",
        hl = "CodeBlock",
        pad_amount = 0,
      },
      list_items = {
        shift_width = 2,
        marker_minus = { text = "●", hl = "@markup.list.markdown" },
        marker_plus = { text = "●", hl = "@markup.list.markdown" },
        marker_star = { text = "●", hl = "@markup.list.markdown" },
        marker_dot = {},
      },
      inline_codes = { enable = false },
      headings = {
        heading_1 = { style = "simple", hl = "Headline1" },
        heading_2 = { style = "simple", hl = "Headline2" },
        heading_3 = { style = "simple", hl = "Headline3" },
        heading_4 = { style = "simple", hl = "Headline4" },
        heading_5 = { style = "simple", hl = "Headline5" },
        heading_6 = { style = "simple", hl = "Headline6" },
      },
    },

    ft = { "markdown", "norg", "rmd", "org" },
    specs = {
      "lukas-reineke/headlines.nvim",
      enabled = false,
    },
  },
  { "folke/github" },
  {
    "ibhagwan/fzf-lua",
    dev = false,
  },
  { "justinsgithub/wezterm-types", lazy = true },
  { "LuaCATS/luassert", name = "luassert-types", lazy = true },
  { "LuaCATS/busted", name = "busted-types", lazy = true },
  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      opts.debug = true
      opts.runtime = "~/projects/neovim/runtime"
      vim.list_extend(opts.library, {
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "luassert-types/library", words = { "assert" } },
        { path = "busted-types/library", words = { "describe" } },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = { show_help = false },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
    },
  },
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
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
  { "akinsho/bufferline.nvim", opts = { options = { separator_style = "slope" } } },
  {
    "echasnovski/mini.align",
    opts = {},
    keys = {
      { "ga", mode = { "n", "v" } },
      { "gA", mode = { "n", "v" } },
    },
  },
}
