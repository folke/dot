-- selene: allow(global_usage)
_G.dump = function(...)
  vim.pretty_print(...)
end

_G.dumpp = function(...)
  local msg = vim.inspect(...)
  vim.notify("```lua\n" .. msg .. "\n```", vim.log.levels.INFO, {
    title = "Debug",
    on_open = function(win)
      vim.api.nvim_win_set_option(win, "conceallevel", 3)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      vim.api.nvim_win_set_option(win, "spell", false)
    end,
  })
end

-- selene: allow(global_usage)
_G.profile = function(cmd, times)
  times = times or 100
  local args = {}
  if type(cmd) == "string" then
    args = { cmd }
    cmd = vim.cmd
  end
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then
      error("Command failed: " .. tostring(ok) .. " " .. vim.inspect({ cmd = cmd, args = args }))
    end
  end
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. "ms")
end

local M = {}

function M.packer_defered()
  vim.cmd([[do User PackerDefered]])
  -- vim.api.nvim_exec_autocmds("User", { pattern = "PackerDefered" })
end

function M.require(mod)
  return M.try(require, mod)
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

function M.toggle(option, silent)
  local info = vim.api.nvim_get_option_info(option)
  local scopes = { buf = "bo", win = "wo", global = "o" }
  local scope = scopes[info.scope]
  local options = vim[scope]
  options[option] = not options[option]
  if silent ~= true then
    if options[option] then
      M.info("enabled vim." .. scope .. "." .. option, "Toggle")
    else
      M.warn("disabled vim." .. scope .. "." .. option, "Toggle")
    end
  end
end

---@param fn fun(buf: buffer, win: window)
function M.float(fn)
  local buf = vim.api.nvim_create_buf(false, true)
  local vpad = 4
  local hpad = 10
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = vim.o.columns - hpad * 2,
    height = vim.o.lines - vpad * 2,
    row = vpad,
    col = hpad,
    style = "minimal",
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  })

  local function close()
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "<ESC>", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.api.nvim_create_autocmd({ "BufDelete", "BufLeave", "BufHidden" }, {
    once = true,
    buffer = buf,
    callback = close,
  })
  fn(buf, win)
end

function M.float_cmd(cmd)
  M.float(function(buf)
    local output = vim.api.nvim_exec(cmd, true)
    local lines = vim.split(output, "\n")
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  end)
end

function M.float_terminal(cmd)
  M.float(function(buf, win)
    vim.fn.termopen(cmd)
    local autocmd = {
      "autocmd! TermClose <buffer> lua",
      string.format("vim.api.nvim_win_close(%d, {force = true});", win),
      string.format("vim.api.nvim_buf_delete(%d, {force = true});", buf),
    }
    vim.cmd(table.concat(autocmd, " "))
    vim.cmd([[startinsert]])
  end)
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
            -- vim.fn.setreg("+", choice)
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

function M.version()
  local v = vim.version()
  if not v.prerelease then
    vim.notify(
      ("Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch),
      vim.log.levels.WARN,
      { title = "Neovim: not running nightly!" }
    )
  end
end

return M
