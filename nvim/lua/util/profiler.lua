local M = {}

---@type table<fun(), true>
M.wrapped = {}

---@type {total:number, time:number, self:number}[]
M.stats = {}
M._require = _G.require
local pack_len = vim.F.pack_len
---@type number[]
M.stack = { 0 }
M.stack_names = {}

function M.stat(name, start)
  M.stats[name] = M.stats[name] or { total = 0, time = 0, self = 0 }
  M.stats[name].total = M.stats[name].total + 1
  local diff = vim.loop.hrtime() - start
  table.remove(M.stack_names)
  if not vim.tbl_contains(M.stack_names, name) then
    M.stats[name].time = M.stats[name].time + diff
  end
  local other = table.remove(M.stack)
  M.stats[name].self = M.stats[name].self + diff - other
  M.stack[#M.stack] = M.stack[#M.stack] + diff
end

function M.wrap(name, fn)
  if M.wrapped[fn] then
    return fn
  end
  M.wrapped[fn] = true
  return function(...)
    local start = vim.loop.hrtime()
    table.insert(M.stack, 0)
    table.insert(M.stack_names, name)
    local ret = pack_len(pcall(fn, ...))
    M.stat(name, start)
    if not ret[1] then
      error(ret[2])
    end
    return unpack(ret, 2, ret.n)
    -- error(ret[2])
  end
end

function M.hook(name, value, done)
  if value == nil then
    return nil
  end
  done = done or {}
  if done[value] then
    return value
  end
  done[value] = true
  if type(value) == "function" then
    return M.wrap(name, value)
  elseif type(value) == "table" and getmetatable(value) == nil then
    for k, v in pairs(value) do
      if type(v) == "function" then
        rawset(value, k, M.wrap(name .. "." .. k .. "()", v))
      elseif type(v) == "table" then
        rawset(value, k, M.hook(name .. "." .. k, v, done))
      end
    end
  end
  return value
end

function M.require(modname)
  if package.loaded[modname] then
    return package.loaded[modname]
  end
  local start = vim.loop.hrtime()
  table.insert(M.stack, 0)
  table.insert(M.stack_names, modname)
  local ret = pack_len(pcall(M._require, modname))
  M.stat(modname, start)
  if ret[1] then
    ret[2] = M.hook(modname, ret[2])
    return unpack(ret, 2, ret.n)
  end
  error(ret[2])
end

function M.stop()
  _G.require = M._require
  local s = {}
  for name, stat in pairs(M.stats) do
    stat.name = name
    s[#s + 1] = stat
  end
  table.sort(s, function(a, b)
    return a.time > b.time
  end)
  for _, stat in ipairs(s) do
    if stat.time / 1e6 > 0.5 or stat.self / 1e6 > 0.5 then
      local time = math.floor(stat.time / 1e6 * 100 + 0.5) / 100
      local time_self = math.floor(stat.time / stat.total / 1e6 * 100 + 0.5) / 100
      local line = {
        { time .. "ms", "Number" },
        {
          time_self .. "ms",
          "Number",
        },
        { stat.total .. "", "Number" },
        { stat.name },
      }
      line[1][1] = line[1][1] .. string.rep(" ", 10 - #line[1][1])
      line[2][1] = line[2][1] .. string.rep(" ", 10 - #line[2][1])
      line[3][1] = line[3][1] .. string.rep(" ", 10 - #line[3][1])
      vim.api.nvim_echo(line, true, {})
    end
  end
end

function M.start()
  _G.require = M.require
end

function M.startup()
  M.start()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = M.stop,
  })
end

vim.api.nvim_create_user_command("ProfileStart", M.start, {})
vim.api.nvim_create_user_command("ProfileStop", M.stop, {})

return M
