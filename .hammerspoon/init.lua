hs.hotkey
    .bind({"cmd", "alt", "ctrl"}, "r", "reload", function() hs.reload() end)

hs.window.animationDuration = 0

-- require("test")
require("spaces")
require("border")

local hyper = require("hyper")
hyper.bindApp({}, "b", "Brave Browser")
hyper.bindApp({"cmd"}, "b", function()
    hs.osascript.javascript([[
        Application("Brave").Window().make()
    ]])
end)
hyper.bindApp({}, "c", "Visual Studio Code - Insiders")
hyper.bindApp({}, "f", "Finder")
hyper.bindApp({}, "w", function() hs.alert("foo") end)

-- hs.hotkey.bind({"cmd"}, "F18", "Scratchpad", function()
--     local app = hs.application.get("kitty")

--     if app then
--         if not app:mainWindow() then
--             app:selectMenuItem({"kitty", "New OS window"})
--         elseif app:isFrontmost() then
--             app:hide()
--         else
--             app:activate()
--         end
--     else
--         hs.application.launchOrFocus("kitty")
--         app = hs.application.get("kitty")
--     end

--     app:mainWindow():moveToUnit '[100,50,0,0]'
--     -- app:mainWindow():setShadows(false)
-- end)

-- hs.hotkey.bind({"cmd"}, "q", "Quit", function()
--     hs.eventtap.keyStroke({'cmd'}, "w")
--     hs.alert("Exited")
-- end)

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("ReloadConfiguration", {start = true})

-- spoon.SpoonInstall:andUse("HSKeybindings", {
--     fn = function(s)
--         local shown = false
--         hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", "Help", function()
--             if shown then
--                 s:hide()
--                 shown = false
--             else
--                 s:show()
--                 shown = true
--             end
--         end)
--     end
-- })
hs.alert.show("Hammerspoon Loaded!")
