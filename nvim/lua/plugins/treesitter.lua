return {
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add caddyfile support
      require("nvim-treesitter.parsers").get_parser_configs().caddy = {
        install_info = {
          url = "https://github.com/Samonitari/tree-sitter-caddy",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
        filetype = "caddy",
      }
      vim.filetype.add({
        pattern = {
          ["Caddyfile"] = "caddy",
        },
      })

      vim.list_extend(opts.ensure_installed, {
        "caddy",
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
        "just",
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
