hs.window.animationDuration = 0

local running = require("running")
require("spaces")
require("border")
require("wm")

local monocle = require("monocle")
local quake = require("quake")

local hyper = require("hyper")
hyper.bindApp({}, "b", "Brave Browser")
hyper.bindApp({ "cmd" }, "b", function()
  hs.osascript.javascript([[
        Application("Brave").Window().make()
    ]])
end)
hyper.bindApp({}, "c", "Visual Studio Code - Insiders")
hyper.bindApp({}, "f", "Finder")
hyper.bindApp({}, "e", "Emacs")
hyper.bindApp({ "cmd" }, "e", function()
  print("/Users/folke/.emacs.d/bin/org-capture")
  print(hs.execute("/Users/folke/.emacs.d/bin/org-capture > /dev/null 2>&1 &", true))
end)

hs.hotkey.bind({ "alt" }, "z", "Zoom", function(event)
  print(hs.inspect(event))
  local win = hs.window.focusedWindow()
  if win then
    monocle.toggle(win)
  end
end)

hs.hotkey.bind({ "cmd" }, "escape", "Scratchpad", quake.toggle)
hyper.bindApp({}, "return", quake.toggle)

local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  -- print(hs.inspect(event))
  local isCmd = event:getFlags():containExactly({ "cmd" })
  local isQ = event:getKeyCode() == hs.keycodes.map["q"]
  if isCmd and isQ then
    local win = hs.window.focusedWindow()
    if win and win:application():name():find("kitty") then
      hs.alert("Use alt+cmd+q instead!")
      return true
    end
  end
end)
tap:start()

hs.loadSpoon("SpoonInstall")
hs.loadSpoon("EmmyLua")
spoon.SpoonInstall:andUse("ReloadConfiguration", { start = true })
spoon.SpoonInstall:andUse("RoundedCorners", { start = true, config = { radius = 8 } })
spoon.SpoonInstall:andUse("AClock", {
  config = { showDuration = 2 },
  fn = function(clock)
    hyper:bind({}, "t", function()
      clock:toggleShow()
    end)
  end,
})

hs.hotkey.bind("alt", "tab", "Switch Windo", function()
  running.switcher()
end)

hs.alert.show("Hammerspoon Loaded!")
