local M = {}

local jids = {} ---@type number[]

function M.preview()
  local function stop()
    local stopped = false
    for _, id in ipairs(jids) do
      if vim.fn.jobstop(id) == 1 then
        stopped = true
      end
    end
    jids = {}
    if stopped then
      Snacks.notify.warn("Stopped markdown preview")
      return true
    end
  end

  ---@param cmd string[]
  local function start(cmd)
    local jid = vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        if code ~= 0 and code ~= 143 then
          Snacks.notify.error(("Command `%s` exited with code %d"):format(table.concat(cmd, " "), code))
        end
        stop()
      end,
    })
    if jid > 0 then
      jids[#jids + 1] = jid
      return true
    end
    Snacks.notify.error(("Failed to start command: %s"):format(table.concat(cmd, " ")))
  end

  if stop() then
    return
  end

  local cmd = { "gh", "markdown-preview", "--disable-auto-open" }
  if vim.bo.filetype == "markdown" then
    cmd[#cmd + 1] = vim.api.nvim_buf_get_name(0)
  end

  if start(cmd) and start({ "brave", "--app=http://localhost:3333" }) then
    Snacks.notify.info("Started markdown preview")
  end
end

return M
