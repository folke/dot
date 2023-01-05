-- selene: allow(global_usage)
_G.profile = function(cmd, times, flush)
  times = times or 100
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    if flush then
      jit.flush(cmd, true)
    end
    cmd()
  end
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. "ms")
end

local M = {}

function M.require(mod)
  local ok, ret = M.try(require, mod)
  return ok and ret
end

function M.try(fn, ...)
  local args = { ... }

  return xpcall(function()
    return fn(unpack(args))
  end, function(err)
    local lines = {}
    table.insert(lines, err)
    table.insert(lines, debug.traceback("", 3))

    M.error(table.concat(lines, "\n"))
    return err
  end)
end

function M.markdown(msg, opts)
  opts = vim.tbl_deep_extend("force", {
    title = "Debug",
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "markdown")
    end,
  }, opts or {})
  require("notify").notify(msg, vim.log.levels.INFO, opts)
end

function M.debug_pcall()
  _G.pcall = function(fn, ...)
    local args = { ... }
    return xpcall(fn and function()
      return fn(unpack(args))
    end, function(err)
      if err:find("DevIcon") or err:find("mason") or err:find("Invalid highlight") then
        return err
      end
      vim.api.nvim_echo({ { err, "ErrorMsg" }, { debug.traceback("", 3), "Normal" } }, true, {})
      return err
    end)
  end
end

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.warn(msg, name)
  vim.notify(msg, vim.log.levels.WARN, { title = name or "init.lua" })
end

function M.error(msg, name)
  vim.notify(msg, vim.log.levels.ERROR, { title = name or "init.lua" })
end

function M.info(msg, name)
  vim.notify(msg, vim.log.levels.INFO, { title = name or "init.lua" })
end

function M.exists(fname)
  local stat = vim.loop.fs_stat(fname)
  return (stat and stat.type) or false
end

function M.fqn(fname)
  fname = vim.fn.fnamemodify(fname, ":p")
  return vim.loop.fs_realpath(fname) or fname
end

function M.clipman()
  local file = M.fqn("~/.local/share/clipman.json")
  if M.exists(file) then
    local f = io.open(file)
    if not f then
      return
    end
    local data = f:read("*a")
    f:close()

    -- allow empty files
    data = vim.trim(data)
    if data ~= "" then
      local ok, json = pcall(vim.fn.json_decode, data)
      if ok and json then
        local items = {}
        for i = #json, 1, -1 do
          items[#items + 1] = json[i]
        end
        vim.ui.select(items, {
          prompt = "Clipman",
        }, function(choice)
          if choice then
            vim.api.nvim_paste(choice, true, 1)
          end
        end)
      else
        vim.notify(("failed to load clipman from %s"):format(file), vim.log.levels.ERROR)
      end
    end
  end
end

function M.debounce(ms, fn)
  local timer = vim.loop.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

function M.throttle(ms, fn)
  local timer = vim.loop.new_timer()
  local running = false
  return function(...)
    if not running then
      local argv = { ... }
      local argc = select("#", ...)

      timer:start(ms, 0, function()
        running = false
        pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
      end)
      running = true
    end
  end
end

function M.test(is_file)
  local file = is_file and vim.fn.expand("%:p") or "./tests"
  local init = vim.fn.glob("tests/*init*")
  require("plenary.test_harness").test_directory(file, { minimal_init = init })
end

function M.version()
  local v = vim.version()
  if v and not v.prerelease then
    vim.notify(
      ("Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch),
      vim.log.levels.WARN,
      { title = "Neovim: not running nightly!" }
    )
  end
end

function M.cowboy()
  ---@type table?
  local id
  for _, key in ipairs({ "h", "j", "k", "l" }) do
    local count = 0
    vim.keymap.set("n", key, function()
      if count >= 10 then
        id = vim.notify("Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          replace = id,
          keep = function()
            return count >= 10
          end,
        })
      else
        count = count + 1
        vim.defer_fn(function()
          count = count - 1
        end, 5000)
        return key
      end
    end, { expr = true, silent = true })
  end
end

return M
