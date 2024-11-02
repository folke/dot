return {
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
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
  {
    "https://github.com/Samonitari/tree-sitter-caddy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        require("nvim-treesitter.parsers").get_parser_configs().caddy = {
          install_info = {
            url = "https://github.com/Samonitari/tree-sitter-caddy",
            files = { "src/parser.c", "src/scanner.c" },
            branch = "master",
          },
          filetype = "caddy",
        }

        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "caddy" })
        vim.filetype.add({
          pattern = {
            ["Caddyfile"] = "caddy",
          },
        })
      end,
    },
    event = "BufRead Caddyfile",
  },
}
