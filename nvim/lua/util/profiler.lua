local M = {}

---@type {count:number, time:number}[]
M.stats = {}
---@type table<string, true>
M.tracked = {}
---@type table<function, true>
M.active = {}
M.mods = {} ---@type table<string, true>
local pack_len = vim.F.pack_len

---@param name string
---@param fn function
function M.track(name, fn)
  return function(...)
    if M.active[fn] then
      return fn(...)
    end
    M.active[fn] = true
    local start = vim.uv.hrtime()
    local result = vim.F.pack_len(pcall(fn, ...))
    local stop = vim.uv.hrtime()
    M.active[fn] = nil
    M.stats[name] = M.stats[name] or { count = 0, time = 0 }
    M.stats[name].count = M.stats[name].count + 1
    M.stats[name].time = M.stats[name].time + (stop - start)
    if result[1] then
      return unpack(result, 2, result.n)
    end
    error(result[2], 2)
  end
end

function M.wrap(name, obj)
  if M.tracked[obj] then
    return obj
  end
  M.tracked[obj] = true
  if type(obj) == "function" then
    return M.track(name, obj)
  elseif type(obj) == "table" then
    for k, v in pairs(obj) do
      obj[k] = M.wrap(name .. "." .. tostring(k), v)
    end
  end
  return obj
end

function M.loader(modname)
  local chunk ---@type function?
  for _, loader in ipairs(package.loaders) do
    if loader ~= M.loader then
      local c = loader(modname)
      if type(c) == "function" then
        chunk = c
        break
      end
    end
  end
  if not chunk then
    return
  end
  if modname:sub(1, 4) == "vim." then
    return chunk
  end
  return function()
    if type(package.loaded[modname]) == "table" then
      return package.loaded[modname]
    end
    local mod = pack_len(pcall(chunk))
    if mod[1] then
      for i = 2, mod.n do
        mod[i] = M.wrap(modname, mod[i])
      end
      return unpack(mod, 2, mod.n)
    end
    error(mod[2])
  end
end

function M.stop()
  local s = {}
  for name, stat in pairs(M.stats) do
    stat.name = name
    s[#s + 1] = stat
  end
  table.sort(s, function(a, b)
    return a.time > b.time
  end)
  debug.sethook(nil)
  vim.defer_fn(function()
    for _, stat in ipairs(s) do
      if stat.time / 1e6 > 0.5 then
        local time = math.floor(stat.time / 1e6 * 100 + 0.5) / 100
        local line = {
          { time .. "ms", "Number" },
          { stat.count .. "", "Number" },
          { stat.name },
        }
        line[1][1] = line[1][1] .. string.rep(" ", 10 - #line[1][1])
        line[2][1] = line[2][1] .. string.rep(" ", 10 - #line[2][1])
        line[3][1] = line[3][1] .. string.rep(" ", 10 - #line[3][1])
        vim.api.nvim_echo(line, true, {})
      end
    end
  end, 1000)
end

---@param method? "loader" | "hook" | "perfanno"
function M.start(method)
  method = method or "perfanno"
  if method == "loader" then
    table.insert(package.loaders, 1, M.loader)
  elseif method == "hook" then
    M.start_hook()
  else
    M.start_perfanno()
  end
end

function M.start_hook()
  local starts = {}
  local names = {}
  debug.sethook(function(what)
    local info = debug.getinfo(2, "Sf")
    if type(package.loaded["lazy.core.util"]) == "table" and info.func == package.loaded["lazy.core.util"].try then
      info = debug.getinfo(3, "Sf")
    end
    if what == "call" then
      starts[info.func] = vim.loop.hrtime()
      return
    end
    names[info.func] = names[info.func] or vim.fn.fnamemodify(info.source:sub(2), ":~:.") .. ":" .. info.linedefined
    local name = names[info.func]
    M.stats[name] = M.stats[name] or { count = 0, time = 0, source = info.source, line = info.linedefined }
    M.stats[name].count = M.stats[name].count + 1
    if starts[info.func] then
      M.stats[name].time = M.stats[name].time + (vim.loop.hrtime() - starts[info.func])
    end
  end, "cr")
end

function M.start_perfanno()
  vim.opt.rtp:append("/home/folke/.local/share/nvim/lazy/perfanno.nvim/")
  vim.opt.rtp:append("/home/folke/.local/share/nvim/lazy/telescope.nvim//")
  local util = require("perfanno.util")
  local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  local bg = string.format("#%06x", hl.bg)
  local fg = "#dc2626"
  local opts = {
    line_highlights = util.make_bg_highlights(bg, fg, 10),
    vt_highlight = util.make_fg_highlight(fg),
  }
  require("perfanno").setup(opts)
  require("perfanno.lua_profile").start(1)
  -- vim.api.nvim_create_autocmd("UIEnter", {
  --   callback = function()
  --     vim.defer_fn(function()
  --       vim.cmd("PerfLuaProfileStop")
  --       vim.defer_fn(function()
  --         vim.cmd("PerfHottestLines")
  --         -- vim.cmd("PerfHottestSymbols")
  --       end, 1000)
  --     end, 5000)
  --   end,
  -- })
end

---@param method? "loader" | "hook" | "perfanno"
function M.startup(method)
  M.start(method)
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      vim.defer_fn(function()
        M.stop()
      end, 5000)
    end,
  })
end

vim.api.nvim_create_user_command("ProfileStart", M.start, {})
vim.api.nvim_create_user_command("ProfileStop", M.stop, {})

return M
