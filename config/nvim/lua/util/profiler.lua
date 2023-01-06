local M = {}

---@type table<fun(), true>
M.wrapped = {}

---@type {total:number, time:number}[]
M.stats = {}
M._require = _G.require
local pack_len = vim.F.pack_len

function M.stat(name, start)
  M.stats[name] = M.stats[name] or { total = 0, time = 0 }
  M.stats[name].total = M.stats[name].total + 1
  M.stats[name].time = M.stats[name].time + vim.loop.hrtime() - start
end

function M.wrap(name, fn)
  if M.wrapped[fn] then
    return fn
  end
  M.wrapped[fn] = true
  return function(...)
    local start = vim.loop.hrtime()
    local ret = pack_len(pcall(fn, ...))
    M.stat(name, start)
    if ret[1] then
      return unpack(ret, 2, ret.n)
    end
    error(ret[2])
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
  elseif type(value) == "table" then
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
  local ret = pack_len(pcall(M._require, modname))
  M.stat(modname, start)
  if ret[1] then
    M.hook(modname, ret[2])
    return unpack(ret, 2, ret.n)
  end
  error(ret[2])
end

function M.start()
  _G.require = M.require
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
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
        if stat.time / 1e6 > 0.5 then
          local time = math.floor(stat.time / 1e6 * 100 + 0.5) / 100
          local line = {
            { time .. "ms", "Number" },
            { stat.total .. "", "Number" },
            { stat.name },
          }
          line[1][1] = line[1][1] .. string.rep(" ", 10 - #line[1][1])
          line[2][1] = line[2][1] .. string.rep(" ", 10 - #line[2][1])
          vim.api.nvim_echo(line, true, {})
        end
      end
    end,
  })
end

return M
