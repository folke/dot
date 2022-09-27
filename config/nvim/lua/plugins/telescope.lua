local M = {
  cmd = { "Telescope" },
  module = "telescope",
  requires = {
    { "nvim-telescope/telescope-file-browser.nvim", module = "telescope._extensions.file_browser" },
    { "nvim-telescope/telescope-z.nvim", module = "telescope._extensions.z" },
    { "nvim-telescope/telescope-project.nvim", module = "telescope._extensions.project" },
    { "nvim-telescope/telescope-symbols.nvim", module = "telescope._extensions.symbols" },
    { "nvim-telescope/telescope-fzf-native.nvim", module = "telescope._extensions.fzf", run = "make" },
  },
}

function M.project_files(opts)
  opts = opts or {}
  opts.show_untracked = true
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    local client = vim.lsp.get_active_clients()[1]
    if client then
      opts.cwd = client.config.root_dir
    end
    require("telescope.builtin").find_files(opts)
  end
end

function M.config()
  -- local actions = require("telescope.actions")
  local trouble = require("trouble.providers.telescope")

  local telescope = require("telescope")
  local borderless = true
  telescope.setup({
    extensions = {
      -- fzf = {
      --   fuzzy = true, -- false will only do exact matching
      --   override_generic_sorter = true, -- override the generic sorter
      --   override_file_sorter = true, -- override the file sorter
      --   case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      --   -- the default case_mode is "smart_case"
      -- },
    },
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
      },
      sorting_strategy = "ascending",
      mappings = { i = { ["<c-t>"] = trouble.open_with_trouble } },
      -- mappings = { i = { ["<esc>"] = actions.close } },
      -- vimgrep_arguments = {
      --   'rg',
      --   '--color=never',
      --   '--no-heading',
      --   '--with-filename',
      --   '--line-number',
      --   '--column',
      --   '--smart-case'
      -- },
      -- prompt_position = "bottom",
      prompt_prefix = " ",
      selection_caret = " ",
      -- entry_prefix = "  ",
      -- initial_mode = "insert",
      -- selection_strategy = "reset",
      -- sorting_strategy = "descending",
      -- layout_strategy = "horizontal",
      -- layout_defaults = {
      --   horizontal = {
      --     mirror = false,
      --   },
      --   vertical = {
      --     mirror = false,
      --   },
      -- },
      -- file_sorter = require"telescope.sorters".get_fzy_file
      -- file_ignore_patterns = {},
      -- generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
      -- shorten_path = true,
      winblend = borderless and 0 or 10,
      -- width = 0.7,
      -- preview_cutoff = 120,
      -- results_height = 1,
      -- results_width = 0.8,
      -- border = false,
      -- color_devicons = true,
      -- use_less = true,
      -- set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
      -- file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
      -- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
      -- qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

      -- -- Developer configurations: Not meant for general override
      -- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    },
  })

  -- telescope.load_extension("frecency")
  telescope.load_extension("fzf")
  telescope.load_extension("z")
  telescope.load_extension("file_browser")
  telescope.load_extension("neoclip")
  -- telescope.load_extension("project")
end

function M.init()
  vim.keymap.set("n", "<leader><space>", function()
    require("plugins.telescope").project_files()
  end, { desc = "Find File" })

  vim.keymap.set("n", "<leader>fd", function()
    require("telescope.builtin").git_files({ cwd = "~/dot" })
  end, { desc = "Find Dot File" })

  vim.keymap.set("n", "<leader>fz", function()
    require("telescope").extensions.z.list({ cmd = { vim.o.shell, "-c", "zoxide query -ls" } })
  end, { desc = "Find Zoxide" })

  vim.keymap.set("n", "<leader>pp", function()
    require("telescope").extensions.project.project({})
  end, { desc = "Find Project" })
end

return M
