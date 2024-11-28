return {
  {
    "ibhagwan/fzf-lua",
    optional = true,
    keys = {
      {
        "<leader>fp",
        LazyVim.pick("files", { cwd = require("lazy.core.config").options.root }),
        desc = "Find Plugin File",
      },
      {
        "<leader>sp",
        function()
          local dirs = { "~/dot/nvim/lua/plugins", "~/projects/LazyVim/lua/lazyvim/plugins" }
          require("fzf-lua").live_grep({
            filespec = "-- " .. table.concat(vim.tbl_values(dirs), " "),
            search = "/",
            formatter = "path.filename_first",
          })
        end,
        desc = "Search Plugin Spec",
      },
    },
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
  -- {
  --   "t-troebst/perfanno.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   opts = function()
  --     local util = require("perfanno.util")
  --     local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  --     local bg = string.format("#%06x", hl.bg)
  --     local fg = "#dc2626"
  --     return {
  --       line_highlights = util.make_bg_highlights(bg, fg, 10),
  --       vt_highlight = util.make_fg_highlight(fg),
  --     }
  --   end,
  --   cmd = "PerfLuaProfileStart",
  -- },
}
