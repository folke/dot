local use_dev = true

if use_dev then
  -- use the local project
  vim.opt.runtimepath:prepend(vim.fn.expand("~/projects/lazy.nvim"))
else
  -- bootstrap from github
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "git@github.com:folke/lazy.nvim.git",
      lazypath,
    })
  end
  vim.opt.runtimepath:prepend(lazypath)
end

require("lazy").setup("config.plugins", {
  defaults = { lazy = true },
  dev = { patterns = jit.os:find("Windows") and {} or { "folke" } },
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
        "matchit",
        "matchparen",
        "netrwPlugin",
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
  debug = true,
})
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>")
