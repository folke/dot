vim.g.prosession_on_startup = 1
vim.g.auto_session_pre_save_cmds = { "tabdo NvimTreeClose" }

-- TODO: add Obsession optims

local sessionsDir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/")

local e = vim.fn.fnameescape

local function getSessionName()
  local cwd = vim.fn.getcwd()
  return cwd:gsub("/", "%%")
end

local function getSessionFile()
  return sessionsDir .. getSessionName() .. ".vim"
end

local function getLastSessionFile()
  local last = io.popen("/bin/ls -t " .. sessionsDir .. "| head -n1")
  return sessionsDir .. last:read()
end

local function loadSession(sessionFile)
  if sessionFile and vim.fn.filereadable(sessionFile) ~= 0 then
    vim.cmd("source " .. e(sessionFile))
  end
  vim.cmd("silent Obsession " .. e(sessionFile))
end

local M = {}

M.start = function()
  local sessionFile = getSessionFile()
  vim.cmd("Obsession " .. e(sessionFile))
end

M.stop = function()
  vim.cmd("Obsession!")
end

M.load = function(opt)
  if type(opt) == "string" then
    return loadSession(opt)
  elseif type(opt) == "table" then
    if opt.file then
      return loadSession(opt.file)
    end
    if opt.last then
      return loadSession(getLastSessionFile())
    end
  end
  return loadSession(getSessionFile())
end

M.list = function()
  return vim.fn.glob(sessionsDir .. "*.vim", true, true)
end

vim.cmd([[au BufReadPre * ++once lua require('config.session').start()]])

return M
