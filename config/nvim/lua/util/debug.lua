-- selene: allow(global_usage)

local M = {}

M.notify = {
  notifs = {},
  orig = vim.notify,
}

function M.notify.lazy(...)
  table.insert(M.notify.notifs, { ... })
end

function M.notify.setup()
  vim.notify = M.notify.lazy
  local check = vim.loop.new_check()
  local start = vim.loop.hrtime()
  check:start(function()
    if vim.notify ~= M.notify.lazy then
      -- use the new notify
    elseif (vim.loop.hrtime() - start) / 1e6 > 1000 then
      -- use the old notify if loading the new one takes over 1 second
      vim.notify = M.notify.orig
    else
      return
    end
    check:stop()
    -- use the new notify
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(M.notify.notifs) do
        vim.notify(unpack(notif))
      end
    end)
  end)
end

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
  return vim.fn.fnamemodify(source, ":~:.") .. ":" .. info.linedefined
end

---@param value any
---@param opts? {loc:string, schedule:boolean}
function M.dump(value, opts)
  opts = opts or {}
  opts.loc = opts.loc or M.get_loc()
  local msg = vim.inspect(value)
  local function notify()
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
  if opts.schedule then
    vim.schedule(notify)
  else
    notify()
  end
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
  for _, name in ipairs({ "config", "data", "state", "cache" }) do
    local path = root .. "/" .. name
    vim.fn.mkdir(path, "p")
    ---@diagnostic disable-next-line: no-unknown
    vim.env[("XDG_%s_HOME"):format(name:upper())] = path
    if name == "config" then
      path = path .. "/nvim"
      pcall(vim.loop.fs_unlink, path)
      vim.loop.fs_symlink(config, path, { dir = true })
    end
  end
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

  _G.dd = function(...)
    M.dump(M.get_value(...), { schedule = true })
  end
  M.notify.setup()
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
