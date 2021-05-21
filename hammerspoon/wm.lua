local dirs = { East = "right", North = "up", West = "left", South = "down" }
local spaces = require("hs._asm.undocumented.spaces")
local desktop = require("desktop")
local running = require("running")

for dir, key in pairs(dirs) do
  hs.hotkey.bind({ "cmd" }, key, "Focus " .. dir, function()
    hs.window.frontmostWindow()["focusWindow" .. dir](hs.window.frontmostWindow(), running.getWindows(true))
  end)
end

hs.hotkey.bind({ "shift", "cmd" }, "down", "Move to next space", function()
  local toDesktop = desktop.active + 1
  if toDesktop > #desktop.layout() then
    toDesktop = 1
  end
  spaces.moveWindowToSpace(hs.window.focusedWindow():id(), desktop.spaceId(toDesktop))
  desktop.changeTo(toDesktop)
end)

hs.hotkey.bind({ "shift", "cmd" }, "up", "Move to prev space", function()
  local toDesktop = desktop.active - 1
  if toDesktop < 1 then
    toDesktop = #desktop.layout()
  end
  spaces.moveWindowToSpace(hs.window.focusedWindow():id(), desktop.spaceId(toDesktop))
  desktop.changeTo(toDesktop)
end)
