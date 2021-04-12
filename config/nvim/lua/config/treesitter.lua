local ts_configs = require("nvim-treesitter.configs")
ts_configs.setup({
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "go",
    "html",
    "javascript",
    "json",
    "jsonc",
    "latex",
    "lua",
    "python",
    "regex",
    "rust",
    "toml",
    "typescript",
    "yaml",
    "tsx",
    "vue",
    "graphql"
  },
  highlight = { enable = true, use_languagetree = true },
  indent = { enable = false },
  context_commentstring = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  }
})
