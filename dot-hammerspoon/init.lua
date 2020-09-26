hs.hotkey
    .bind({"cmd", "alt", "ctrl"}, "r", "reload", function() hs.reload() end)

hs.window.animationDuration = 0

-- require("test")
require("spaces")
require("border")
require("wm")
local quake = require("quake")

local hyper = require("hyper")
hyper.bindApp({}, "b", "Brave Browser")
hyper.bindApp({"cmd"}, "b", function()
    hs.osascript.javascript([[
        Application("Brave").Window().make()
    ]])
end)
hyper.bindApp({}, "c", "Visual Studio Code - Insiders")
hyper.bindApp({}, "f", "Finder")

hs.hotkey.bind({"cmd"}, "escape", "Scratchpad", quake.toggle)
hyper.bindApp({}, "return", quake.toggle)

tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    -- print(hs.inspect(event))
    local isCmd = event:getFlags():containExactly({"cmd"})
    local isQ = event:getKeyCode() == hs.keycodes.map["q"]
    if isCmd and isQ then
        local win = hs.window.focusedWindow()
        if win and win:application():name() == "kitty" then
            hs.alert("Use alt+cmd+q instead!")
            return true
        end
    end
end)
tap:start()

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("ReloadConfiguration", {start = true})
spoon.SpoonInstall:andUse("RoundedCorners",
                          {start = true, config = {radius = 8}})

local getWindows = function()
    return hs.fnutils.map(hs.window.filter.new():getWindows(), function(win)
        if win ~= hs.window.focusedWindow() then
            return {
                text = win:title(),
                subText = win:application():title(),
                image = hs.image
                    .imageFromAppBundle(win:application():bundleID()),
                win = win
            }
        end
    end)
end

local chooser = hs.chooser.new(function(choice)
    print(hs.inspect(choice))
    if choice ~= nil then choice.win:focus() end
end)

-- alternatively, call .nextWindow() or .previousWindow() directly (same as hs.window.switcher.new():next())
hs.hotkey.bind('alt', 'tab', 'Next window', function()
    chooser:placeholderText("Switch to Window"):searchSubText(true):choices(
        getWindows()):show()
end)

hs.alert.show("Hammerspoon Loaded!")
