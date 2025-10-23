---@module 'lazy'

return {
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      statuscolumn = { folds = { open = false } },
      notifier = { sort = { "added" } },
      scroll = { debug = false },
      image = {
        force = false,
        enabled = true,
        debug = { request = false, convert = false, placement = false },
        math = { enabled = true },
        doc = { inline = true, float = true },
      },
      picker = {
        previewers = {
          diff = { builtin = false },
          git = { builtin = false },
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
            p:find()
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
        chunk = { enabled = true },
      },
      dashboard = { example = "advanced" },
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
}
