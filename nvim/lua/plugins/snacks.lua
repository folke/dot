return {
  { "yanky.nvim", keys = { { "<leader>p", false, mode = { "n", "x" } } } },
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      profiler = {
        runtime = "~/projects/neovim/runtime/",
        presets = {
          on_stop = function()
            Snacks.profiler.scratch()
          end,
        },
      },
      input = {},
      -- styles = { terminal = { position = "top" } },
      indent = {
        scope = {
          treesitter = {
            -- blocks = true,
            enabled = true,
          },
        },
      },
      ---@type snacks.scroll.Config
      scroll = {},
      dashboard = { example = "github" },
      -- dashboard = { example = "advanced" },
      gitbrowse = {
        open = function(url)
          vim.fn.system(" ~/dot/config/hypr/scripts/quake")
          vim.ui.open(url)
        end,
      },
    },
    -- stylua: ignore
    keys = {
      -- { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>ps", function() Snacks.profiler.scratch() end },
      {
        "<leader>pd",
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
  {
    "snacks.nvim",
    opts = function()
      LazyVim.on_load("which-key.nvim", function()
        Snacks.toggle.profiler():map("<leader>pp")
        Snacks.toggle.profiler_highlights():map("<leader>ph")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.zen():map("<leader>z")
      end)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, Snacks.profiler.status())
    end,
  },
}
