local use_dev = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local devpath = vim.fn.expand("~/projects/lazy.nvim")
if use_dev and vim.uv.fs_stat(devpath) then
  lazypath = devpath
elseif not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
  vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

local M = {}

local override = {} ---@type LazySpec

-- If we are in a git worktree, use this as the plugin dir
local cwd = assert(vim.uv.cwd())
if cwd:find("git-worktrees", 1, true) and vim.fn.isdirectory("lua") == 1 then
  local root = vim.fn.systemlist({ "git", "rev-parse", "--path-format=absolute", "--git-common-dir" })[1]
  if root and root ~= "" then
    root = vim.fs.dirname(root) ---@type string
    override = {
      name = vim.fs.basename(root),
      dir = cwd,
    }
  end
end

---@param opts LazyConfig
function M.load(opts)
  opts = vim.tbl_deep_extend("force", {
    spec = {
      override,
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
    checker = {
      enabled = true,
      notify = false,
    },
    diff = {
      cmd = "terminal_git",
    },
    rocks = { hererocks = true },
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

return M
