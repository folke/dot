local format = string.format
local concat = table.concat
local insert = table.insert
local inspect = vim.inspect

local function inspect_args(...)
  local res = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    insert(res, inspect(v, { newline = "", indent = "" }))
  end
  return concat(res, ", ")
end

local function get_timer_fn()
  return vim and vim.loop and (function()
    local hrtime = vim.loop.hrtime
    local start = hrtime()
    return function() return (hrtime() - start) / 1e6 end
  end)() or os.clock
end

local clock = get_timer_fn()

local wrapped_fns = {}

local wrapped_mt = {
  __call = function(t, ...)
    local fn = rawget(t, "fn")
    local argc = select("#", ...)
    local args = { ... }
    local start = clock()
    return (function(...)
      local finish = clock()
      insert(t.times, { start = start, finish = finish, args = args, argc = argc })
      return ...
    end)(fn(...))
  end
}

local function wrap(fn)
  if type(fn) == "table" and getmetatable(fn) == wrapped_mt then return fn end
  if wrapped_fns[fn] then return wrapped_fns[fn] end
  local R = setmetatable({
    fn = fn,
    -- info = debug.getinfo(fn);
    info = select(2, pcall(debug.getinfo, fn)),
    times = {}
  }, wrapped_mt)
  wrapped_fns[fn] = R
  return R
end

local linear_mt = {
  __tostring = function(t)
    return format("%s(%s): %gms (%f -> %f)", t.node.name or "",
                  inspect_args(unpack(t.time.args, 1, t.time.argc)), t.time.finish - t.time.start,
                  t.time.start, t.time.finish)
  end
}

local function linearized()
  local times = {}
  for fn, t in pairs(wrapped_fns) do
    for _, time in ipairs(t.times) do
      insert(times, setmetatable({ time = time, node = t }, linear_mt))
    end
  end
  return times
end

WRAP = function(fn) return fn end
if os.getenv("AK_PROFILER") then
  require = wrap(require)
  require.name = "require"
  WRAP = wrap
  function ASHKAN_PROFILE_FINISH_FUNCTION(filename)
    linearized()
    local data = linearized()
    table.sort(data, function(a, b)
      if a.time.start == b.time.start then
        return a.time.finish < b.time.finish
      else
        return a.time.start < b.time.start
      end
    end)
    local function mktree(X, i)
      local R = { n = X, c = {} }
      local S
      while data[i] do
        local t = data[i]
        local is_contained = X.time.start < t.time.start and t.time.finish < X.time.finish
        if is_contained then
          S, i = mktree(t, i + 1)
          insert(R.c, S)
        else
          return R, i
        end
      end
      return R, i
    end
    local T = mktree(setmetatable({
      node = { name = "root" },
      time = { args = {}, argc = 0, start = 0, finish = math.huge }
    }, linear_mt), 1)
    local function print_em(x, depth)
      depth = depth or 0
      io.write(("  "):rep(depth), tostring(x.n), "\n")
      for i, v in ipairs(x.c) do print_em(v, depth + 1) end
    end
    if filename then
      io.output(io.open(filename, "w"))
    else
      io.output(io.stderr)
    end
    print_em(T)
    os.exit(0)
  end
  vim.schedule(ASHKAN_PROFILE_FINISH_FUNCTION)
end
function M(name, fn, ...)
  local X = wrap(fn)
  X.name = name
  return X(...)
end

return {
  -- profile_startup_time = function(...)
  --   local info = debug.getinfo(1)
  --   local filename = info.short_src
  --   local output_filename = os.tmpname()
  --   vim.cmd("edit "..output_filename)
  --   -- return coroutine.wrap(function(...)
  --   --   local co = coroutine.running()
  --     local handle
  --     handle = vim.loop.spawn("nvim", {
  --       stdio = {nil, nil, 2};
  --       env = {
  --         "ASHKAN_PROFILER=1";
  --       };
  --       args = vim.tbl_flatten {
  --         "-c"; "luafile "..filename;
  --         {...};
  --         "-c"; format("lua ASHKAN_PROFILE_FINISH_FUNCTION(%q)", output_filename);
  --       };
  --     }, function()
  --       handle:close()
  --       -- coroutine.resume(co)
  --     end)
  --     -- coroutine.yield()
  --     -- local file = io.open(output_filename)
  --     -- if not file then
  --     --   return
  --     -- end
  --     -- local data = file:read "*a"
  --     -- file:close()
  --     -- -- os.remove(output_filename)
  --     -- return data
  --   -- end)
  -- end;
  linearized = linearized,
  wrap = wrap
}
