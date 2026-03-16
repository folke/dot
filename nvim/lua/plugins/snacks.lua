---@module 'lazy'

return {
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      statuscolumn = { folds = { open = false } },
      notifier = { sort = { "added" } },
      scroll = { debug = false },
      -- animate = {
      --   fps = 240,
      -- },
      image = {
        force = false,
        -- enabled = false,
        debug = { request = false, convert = false, placement = false },
        math = { enabled = true },
        -- doc = { inline = true, float = true },
      },
      lazygit = {
        config = {
          os = {
            edit = 'test -z "$NVIM"; and nvim -- {{filename}}; or begin; nvim --server "$NVIM" --remote-send "q"; and nvim --server "$NVIM" --remote {{filename}}; end',
          },
        },
      },
      picker = {
        previewers = {
          diff = { style = "fancy" },
        },
        debug = { scores = false, leaks = false, explorer = false, files = false, proc = true },
        sources = {
          files = {
            hidden = true,
          },
          grep = {
            hidden = true,
          },
          select = {
            kinds = {
              sidekick_cli = {
                layout = { preset = "vscode" },
              },
              sidekick_prompt = {
                layout = { preset = "vscode" },
              },
            },
          },
          explorer = {
            hidden = true,
            layout = {
              preset = "sidebar",
              preview = { main = true, enabled = false },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<c-l>"] = { "toggle_lua", mode = { "n", "i" } },
            },
          },
        },
        actions = {
          toggle_lua = function(p)
            local opts = p.opts --[[@as snacks.picker.grep.Config]]
            opts.ft = not opts.ft and "lua" or nil
            opts.dirs = opts.ft == "lua" and { "lua" } or nil
            p:refresh()
          end,
        },
      },
      profiler = {
        runtime = "~/projects/neovim/runtime/",
        presets = {
          on_stop = function()
            Snacks.profiler.scratch()
          end,
        },
      },
      indent = {
        -- enabled = true,
        chunk = { enabled = true },
      },
      dashboard = { example = vim.fn.has("win32") == 0 and "github" or nil },
      gitbrowse = {
        open = function(url)
          vim.fn.system(" ~/dot/config/hypr/scripts/quake")
          vim.ui.open(url)
        end,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Open" },
      { "<leader>dd", function() Snacks.picker.grep({search = "^(?!\\s*--).*\\b(bt|dd)\\(", args = {"-P"}, live = false, ft = "lua"}) end, desc = "Debug Searcher" },
      { "<leader>t", function() 
        local file = vim.uv.fs_stat("TODO.md") and "TODO.md" or "~/dot/TODO.md"
        Snacks.scratch({ icon = " ", name = "Todo", ft = "markdown", file = file })
      end, desc = "Todo List" },
      { "<leader>T", function() 
        Snacks.scratch({ icon = " ", name = "Todo", ft = "markdown", file = "~/dot/TODO.md" })
      end, desc = "Todo List" },
      {
        "<leader>dpd",
        desc = "Debug profiler",
        function()
          if not Snacks.profiler.running() then
            Snacks.notify("Profiler debug started")
            Snacks.profiler.start()
          else
            Snacks.profiler.debug()
            Snacks.notify("Profiler debug stopped")
          end
        end,
      },
    },
  },
  -- { "folke/todo-comments.nvim", enabled = false },
  -- { "nvim-mini/mini.hipatterns", enabled = false },
  -- {
  --   "folke/snacks.nvim",
  --   opts = {
  --     scroll = { enabled = false },
  --     indent = { enabled = false },
  --     statuscolumn = { enabled = false },
  --   },
  -- }, -- disable scroll for testing
}
