-- selene: allow(global_usage)

local M = {}

function M.get_loc()
  local me = debug.getinfo(1, "S")
  local level = 2
  local info = debug.getinfo(level, "S")
  while info and info.source == me.source do
    level = level + 1
    info = debug.getinfo(level, "S")
  end
  info = info or me
  local source = info.source:sub(2)
  source = vim.loop.fs_realpath(source) or source
  return source .. ":" .. info.linedefined
end

---@param value any
---@param opts? {loc:string}
function M.dump(value, opts)
  opts = opts or {}
  opts.loc = opts.loc or M.get_loc()
  if vim.in_fast_event() then
    return vim.schedule(function()
      M.dump(value, opts)
    end)
  end
  opts.loc = vim.fn.fnamemodify(opts.loc, ":~:.")
  local msg = vim.inspect(value)
  vim.notify(msg, vim.log.levels.INFO, {
    title = "Debug: " .. opts.loc,
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, "lua") then
        vim.bo[buf].filetype = "lua"
      end
    end,
  })
end

function M.get_value(...)
  local value = { ... }
  return vim.tbl_islist(value) and vim.tbl_count(value) <= 1 and value[1] or value
end

function M.switch(config)
  config = vim.loop.fs_realpath(config)
  local config_name = vim.fn.fnamemodify(config, ":p:~"):gsub("[\\/]", "."):gsub("^~%.", ""):gsub("%.$", "")
  local root = vim.fn.fnamemodify("~/.nvim/" .. config_name, ":p"):gsub("/$", "")
  vim.fn.mkdir(root, "p")

  ---@type table<string,string>
  local old = {}
  ---@type table<string,string>
  local new = {}

  for _, name in ipairs({ "config", "data", "state", "cache" }) do
    local path = root .. "/" .. name
    vim.fn.mkdir(path, "p")
    local xdg = ("XDG_%s_HOME"):format(name:upper())
    old[xdg] = vim.env[xdg] or vim.env.HOME .. "/." .. name
    new[xdg] = path
    if name == "config" then
      path = path .. "/nvim"
      pcall(vim.loop.fs_unlink, path)
      vim.loop.fs_symlink(config, path, { dir = true })
    end
  end

  ---@param env table<string,string>
  local function apply(env)
    for k, v in pairs(env) do
      vim.env[k] = v
    end
  end

  local function wrap(fn)
    return function(...)
      apply(old)
      local ok, ret = pcall(fn, ...)
      apply(new)
      if ok then
        return ret
      end
      error(ret)
    end
  end

  vim.fn.termopen = wrap(vim.fn.termopen)

  apply(new)

  local ffi = require("ffi")
  ffi.cdef([[char *runtimepath_default(bool clean_arg);]])
  local rtp = ffi.string(ffi.C.runtimepath_default(false))
  vim.go.rtp = rtp
  vim.go.pp = rtp
  dofile(root .. "/config/nvim/init.lua")
end

function M.setup()
  _G.d = function(...)
    M.dump(M.get_value(...))
  end

  _G.dd = _G.d

  vim.pretty_print = _G.d
  -- make all keymaps silent by default
  local keymap_set = vim.keymap.set
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    return keymap_set(mode, lhs, rhs, opts)
  end
end
M.setup()

return M
