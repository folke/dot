local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function() hyper:enter() end
hyper.released = function() hyper:exit() end

-- Set the key you want to be HYPER to F19 in karabiner or keyboard
-- Bind the Hyper key to the hammerspoon modal
hs.hotkey.bind({}, 'F18', hyper.pressed, hyper.released)

hyper.launch = function(appName)
    local win = hs.window.focusedWindow()
    -- if the focused app is the app we need, cycle its windows
    if win and win:application():name() == appName then
        win:application():getWindows()
    end
    local app = hs.application.get(appName)
    print(hs.inspect(app))
    if app == nil then
        hs.application.launchOrFocus(appName)
    else
        app:activate()
        if newWindow then
            -- local item = app:findMenuItem({"File", "New Window"})
            hs.eventtap.keyStroke({'cmd'}, "n")
        end
    end

    -- hs.application.launchOrFocus(app)  
end

hyper.bindApp = function(mods, key, app)
    local fn = function() hs.application.open(app) end
    if type(app) == "function" then fn = app end
    hyper:bind(mods, key, fn)
end

return hyper
