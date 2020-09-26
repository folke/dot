local appw = hs.application.watcher
local module = {apps = {}, observers = {}, focused = nil, focusedPid = nil}

module.appEvents = {
    [appw.activated] = "activated",
    [appw.deactivated] = "deactivated",
    [appw.hidden] = "hidden",
    [appw.launched] = "launched",
    [appw.launching] = "launching",
    [appw.terminated] = "terminated",
    [appw.unhidden] = "unhidden"
}

module.events = {
    focused = "focused",
    framed = "framed",
    unfocused = "unfocused"
}

module.triggerChange = function(app, win, event)
    if event == module.events.unfocused then
        module.focused = nil
        module.focusedPid = nil
    else
        module.focused = win
        module.focusedPid = app:pid()
    end
    local winTitle = ""
    if win then winTitle = win:title() end
    print("* " .. event .. ":" .. app:name() .. " -- " .. winTitle)
    for _, fn in ipairs(module._listeners) do fn(module.focused) end
end

module._listeners = {}
module.onChange = function(fn)
    table.insert(module._listeners, fn)
    fn(module.focused)
end

module.appEventWatcher = function(app, ax)
    module.apps[app:pid()] = app
    local w = hs.axuielement.observer.new(app:pid())
    w:addWatcher(ax, "AXFocusedWindowChanged")
    w:addWatcher(ax, "AXResized")
    w:addWatcher(ax, "AXMoved")
    w:addWatcher(ax, "AXUIElementDestroyed")
    w:callback(function(_, axel, notif, notifData)
        if notif == "AXUIElementDestroyed" then
            if not app:focusedWindow() and module.focused and
                module.focused:application() and
                module.focused:application():pid() == app:pid() then
                module.triggerChange(app, nil, module.events.unfocused)
            end
            return
        end
        local win = axel:asHSWindow()
        if notif == "AXFocusedWindowChanged" then
            module.triggerChange(app, win, module.events.focused)
        elseif module.focused and module.focused:id() == win:id() then
            module.triggerChange(app, win, module.events.framed)
        end
    end)
    w:start()
    module.observers[app:pid()] = w
end

module.appWatcher = appw.new(function(appName, event, app)
    if appName == nil then appName = "" end
    -- print("  appWatcher:" .. module.appEvents[event] .. ": " .. appName)

    if event == appw.launching then return end

    if event == appw.terminated then
        module.apps[app:pid()] = nil
        if module.observers[app:pid()] ~= nil then
            module.observers[app:pid()]:stop()
            module.observers[app:pid()] = nil
        end
        return
    end

    if event == appw.terminated or event == appw.deactivated then
        if app:pid() == module.focusedPid then
            module.triggerChange(app, nil, module.events.unfocused)
        end
    end

    if module.apps[app:pid()] == nil then
        local ax = hs.axuielement.applicationElement(app)
        -- when the app just launched, we might have to wait for
        -- the next event to setup the observers
        if ax:isValid() then module.appEventWatcher(app, ax) end
    end

    if event == appw.activated or event == appw.launched then
        local win = app:focusedWindow()
        if win ~= nil then
            module.triggerChange(app, win, module.events.focused)
        end
    end
end)

module.start = function()
    local win = hs.window.focusedWindow()
    if win ~= nil then
        module.focused = win
        module.focusedPid = win:pid()
    end
    module.appWatcher:start()
end

module.start()

-- print(hs.inspect(module.focusedWindow():title()))
-- print(hs.inspect(module.focusedApplication():title()))

return module
