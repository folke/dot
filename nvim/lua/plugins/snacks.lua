return {
  { "yanky.nvim", keys = { { "<leader>p", false, mode = { "n", "x" } } } },
  {
    "snacks.nvim",
    opts = {
      profiler = { runtime = "~/projects/neovim/runtime/" },
      dashboard = { example = "github" },
      gitbrowse = {
        config = function(opts, defaults)
          dd(opts, defaults)
        end,
        open = function(url)
          vim.fn.system(" ~/dot/config/hypr/scripts/quake")
          vim.ui.open(url)
        end,
      },
    },
    keys = {
      {
        "<leader>pp",
        function()
          if not Snacks.profiler.toggle() then
            Snacks.profiler.pick({ min_time = 0.2 })
          end
        end,
      },
      {
        "<leader>ph",
        function()
          Snacks.profiler.highlight()
        end,
      },
      {
        "<leader>pd",
        function()
          if not Snacks.profiler.enabled then
            Snacks.notify("Profiler debug started")
            Snacks.profiler.start()
          else
            Snacks.profiler.debug()
            Snacks.notify("Profiler debug stopped")
          end
          -- Snacks.profiler.toggle()
          if not Snacks.profiler.enabled then
            Snacks.profiler.pick({})
          end
        end,
      },
    },
  },
}
