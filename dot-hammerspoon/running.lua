local appw = hs.application.watcher
local module = {apps = {}, observers = {}, windows = {}}

local spaces = require("hs._asm.undocumented.spaces")

module.appEvents = {
    [appw.activated] = "activated",
    [appw.deactivated] = "deactivated",
    [appw.hidden] = "hidden",
    [appw.launched] = "launched",
    [appw.launching] = "launching",
    [appw.terminated] = "terminated",
    [appw.unhidden] = "unhidden"
}

module.getWindowsPerSpace = function()
    local ret = {}
    for _, windows in pairs(module.windows) do
        for _, ax in pairs(windows) do
            if ax:isValid() then
                local win = ax:asHSWindow()
                for _, space in pairs(win:spaces()) do
                    if ret[space] == nil then ret[space] = {} end
                    ret[space][win:id()] = win
                end
            end
        end
    end
    return ret
end

module.getWindows = function()
    local ret = {}
    for _, windows in pairs(module.windows) do
        for _, ax in pairs(windows) do
            if ax:isValid() then
                local win = ax:asHSWindow()
                ret[win:id()] = win
            end
        end
    end
    return ret
end

module._addAppWindow = function(app, ax)
    if ax ~= nil and ax.AXSubrole == "AXStandardWindow" then
        local pid = app:pid()
        if module.windows[pid] == nil then module.windows[pid] = {} end
        local win = ax:asHSWindow()
        module.windows[pid][win:id()] = ax
    end
end

module._updateAppWindows = function(app, ax)
    if module.windows[app:pid()] == nil then module.windows[app:pid()] = {} end
    for _, child in ipairs(ax.AXChildren) do
        if child:matchesCriteria("AXWindow") then
            module._addAppWindow(app, child)
        end
    end

    module._addAppWindow(app, ax.AXMainWindow)
    module._addAppWindow(app, ax.AXFocusedWindow)

    module.windows[app:pid()] = hs.fnutils.filter(module.windows[app:pid()],
                                                  function(el)
        return el:isValid()
    end)
end

module._watchApp = function(app)
    if module.apps[app:pid()] ~= nil then return end
    local ax = hs.axuielement.applicationElement(app)
    -- when the app just launched, we might have to wait for
    -- the next event to setup the observers
    if ax:isValid() and app:kind() > 0 then
        print("## watching: " .. app:name())
        module.apps[app:pid()] = app
        module._updateAppWindows(app, ax)
        local w = hs.axuielement.observer.new(app:pid())
        w:addWatcher(ax, "AXFocusedWindowChanged")
        w:addWatcher(ax, "AXMainWindowChanged")
        -- w:addWatcher(ax, "AXUIElementDestroyed")
        w:callback(function(_, axel, notif, notifData)
            if not axel:matchesCriteria("AXWindow") then return end
            module._updateAppWindows(app, ax)
        end)
        w:start()
        module.observers[app:pid()] = w
    end

end

module._updateSpaces = function()
    for _, space in pairs(spaces.layout()[spaces.mainScreenUUID()]) do
        for _, w in pairs(spaces.allWindowsForSpace(space)) do
            module._addAppWindow(w:application(),
                                 hs.axuielement.windowElement(w))
        end
    end
end

module._updateRunning = function()
    for a, app in ipairs(hs.application.runningApplications()) do
        module._watchApp(app)
    end
end

module.switcher = function()
    if module._chooser == nil then
        module._chooser = hs.chooser.new(
                              function(choice)
                if choice ~= nil then choice.win:focus() end
            end):bgDark(true):placeholderText("Switch to Window"):searchSubText(
                              true)
    elseif module._chooser:isVisible() then
        module._chooser:hide()
        return
    end
    local windows = hs.fnutils.map(running.getWindows(), function(win)
        return {
            text = win:title(),
            subText = win:application():title(),
            image = hs.image.imageFromAppBundle(win:application():bundleID()),
            win = win
        }
    end)
    module._chooser:choices(windows):show()
end

module._appWatcher = appw.new(function(appName, event, app)
    if appName == nil then appName = "" end

    if event == appw.launching then return end

    if event == appw.terminated then
        module.apps[app:pid()] = nil
        if module.observers[app:pid()] ~= nil then
            module.observers[app:pid()]:stop()
            module.observers[app:pid()] = nil
        end
        return
    end

    if module.apps[app:pid()] == nil then module._watchApp(app) end
end)

module._spaceWatcher = hs.spaces.watcher.new(module._updateRunning)

module.start = function()
    module._updateSpaces()
    module._spaceWatcher:start()
    module._appWatcher:start()
end

module.start()

return module
