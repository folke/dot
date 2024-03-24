local use_dev = true

if use_dev then
  vim.opt.runtimepath:prepend(vim.fn.expand("~/projects/lazy.nvim"))
else
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
    vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
  end
  vim.opt.rtp:prepend(lazypath)
end

---@param opts LazyConfig
return function(opts)
  opts = vim.tbl_deep_extend("force", {
    spec = {
      {
        "LazyVim/LazyVim",
        import = "lazyvim.plugins",
        opts = {
          -- colorscheme = "rose-pine",
          news = {
            lazyvim = true,
            neovim = true,
          },
        },
      },
      { import = "plugins" },
    },
    defaults = { lazy = true },
    dev = {
      patterns = { "folke", "LazyVim" },
      fallback = jit.os:find("Windows"),
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true },
    diff = {
      cmd = "terminal_git",
    },
    performance = {
      cache = {
        enabled = true,
        -- disable_events = {},
      },
      rtp = {
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    ui = {
      custom_keys = {
        ["<localleader>d"] = function(plugin)
          dd(plugin)
        end,
      },
    },
    debug = false,
  }, opts or {})
  require("lazy").setup(opts)
end
