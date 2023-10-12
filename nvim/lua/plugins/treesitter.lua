return {
  -- { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "cmake",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now
        "css",
        "devicetree",
        "gitcommit",
        "gitignore",
        "glsl",
        "go",
        "graphql",
        "http",
        "kconfig",
        "meson",
        "ninja",
        "nix",
        "org",
        "php",
        "scss",
        "sql",
        "svelte",
        "vue",
        "wgsl",
      })
    end,
  },
}
