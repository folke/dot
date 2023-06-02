return {
  -- Edgy.nvim stuff
  -- { "anuvyklack/windows.nvim", enabled = false },
  -- { "echasnovski/mini.animate", enabled = false },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "Sidebar",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = function()
      local buf_var = function(key, value)
        return function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          local ok, bvar = pcall(vim.api.nvim_buf_get_var, buf, key)
          return ok and bvar == value
        end
      end
      local opts = {
        layout = {
          bottom = {
            views = {
              "Trouble",
              { ft = "qf", title = "QuickFix" },
              "mason",
              { ft = "lspinfo", size = { height = 0.3 } },
              { ft = "help", size = { height = 20 } },
              -- { ft = "spectre_panel", size = { width = 45 } },
            },
          },
          left = {
            views = {
              {
                title = "Neo-Tree",
                ft = "neo-tree",
                filter = buf_var("neo_tree_source", "filesystem"),
                size = { height = 0.5 },
              },
              {
                title = "Neo-Tree Git",
                ft = "neo-tree",
                filter = buf_var("neo_tree_source", "git_status"),
                pinned = true,
                open = function()
                  vim.cmd([[Neotree position=right git_status]])
                end,
              },
              {
                title = "Neo-Tree Buffers",
                ft = "neo-tree",
                filter = buf_var("neo_tree_source", "buffers"),
                pinned = true,
                open = function()
                  vim.cmd([[Neotree position=top buffers]])
                end,
              },
              {
                ft = "spectre_panel",
                size = { width = 45 },
                pinned = false,
                open = function()
                  require("spectre").open()
                end,
              },
              {
                ft = "Outline",
                pinned = true,
                size = { height = 0.3 },
                open = "SymbolsOutline",
              },
              {
                title = "Neo-Tree Symbols",
                ft = "neo-tree",
                filter = buf_var("neo_tree_source", "document_symbols"),
                pinned = true,
                open = function()
                  vim.cmd([[Neotree position=bottom document_symbols]])
                end,
              },
              "neo-tree",
            },
          },
        },
      }
      return opts
    end,
  },
}
