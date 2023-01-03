local M = {}

---@type {event:string, func:fun(), start?:number, stop?:number, id:number}[]
local events = {}
local names = {}
local hook_time = 0
local hook_total = 0

local function hook(event)
  local now = vim.loop.hrtime()
  hook_total = hook_total + 1

  local info = debug.getinfo(2, "fn")
  local func = info.func
  local name = info.name
  if func then
    names[func] = name
    local id = #events + 1
    if event == "call" then
      events[id] = { event = "call", func = func, start = now, id = id }
    elseif event == "return" then
      events[id] = { event = "return", func = func, stop = now, id = id }
    end
  end
  hook_time = hook_time + vim.loop.hrtime() - now
end

function M.stats()
  ---@type table<string,{total:number, time:number, name:string}>
  local stats = {}
  ---@type {func:fun(), start:number}[]
  local stack = {}
  for _, event in ipairs(events) do
    if event.event == "call" then
      stack[#stack + 1] = event
    elseif event.event == "return" then
      local info = debug.getinfo(event.func, "Snf")
      if info.what ~= "C" then
        while #stack > 0 and stack[#stack].func ~= info.func do
          table.remove(stack)
        end
        local entry = stack[#stack]
        if entry then
          local source = info.source:sub(2)
          local modname = source:match("/lua/(.*)%.lua")
          if modname then
            source = modname:gsub("/", ".")
          end
          source = source .. ":" .. info.linedefined
          if names[event.func] then
            source = source .. ":" .. names[event.func] .. "()"
          end
          local name = source
          stats[name] = stats[name] or { total = 0, time = 0, name = name }
          stats[name].total = stats[name].total + 1
          local time = event.stop - entry.start - (hook_time / hook_total * (event.id - entry.id))
          stats[name].time = stats[name].time + time / 1e6
        end
      end
    end
  end
  return vim.tbl_values(stats)
end

function M.start()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      debug.sethook()
      local stats = M.stats()
      table.sort(stats, function(a, b)
        return a.time > b.time
      end)
      for _, stat in ipairs(stats) do
        if stat.time > 1 then
          print(stat.time .. "\t" .. stat.total .. "\t" .. stat.name .. "\n")
        end
      end
    end,
  })
  debug.sethook(hook, "cr")
end

return M
