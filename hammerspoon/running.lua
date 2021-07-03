local appw = hs.application.watcher
local module = { apps = {}, observers = {}, windows = {} }

local spaces = require("hs._asm.undocumented.spaces")
local desktop = require("desktop")

module.appEvents = {
  [appw.activated] = "activated",
  [appw.deactivated] = "deactivated",
  [appw.hidden] = "hidden",
  [appw.launched] = "launched",
  [appw.launching] = "launching",
  [appw.terminated] = "terminated",
  [appw.unhidden] = "unhidden",
}

module.events = { focused = "focused", framed = "framed", closed = "closed", created = "created", hidden = "hidden" }

module.getWindowsPerSpace = function()
  local ret = {}
  for _, windows in pairs(module.windows) do
    for _, ax in pairs(windows) do
      if ax:isValid() then
        local win = ax:asHSWindow()
        for _, space in pairs(win:spaces()) do
          if ret[space] == nil then
            ret[space] = {}
          end
          ret[space][win:id()] = win
        end
      end
    end
  end
  return ret
end

---@return hs.window[]
module.getWindows = function(currentSpaceOnly)
  local mySpace = desktop.activeSpace()
  local ret = {}
  for _, windows in pairs(module.windows) do
    for _, ax in pairs(windows) do
      if ax:isValid() then
        local win = ax:asHSWindow()
        local keep = false
        if currentSpaceOnly then
          for _, space in pairs(win:spaces()) do
            if space == mySpace then
              keep = true
            end
          end
        else
          keep = true
        end
        if keep then
          table.insert(ret, win)
        end
      end
    end
  end
  return ret
end

module._addAppWindow = function(app, ax)
  if ax ~= nil and ax.AXSubrole == "AXStandardWindow" then
    local pid = app:pid()
    if module.windows[pid] == nil then
      module.windows[pid] = {}
    end
    local win = ax:asHSWindow()
    if win and not module.windows[pid][win:id()] then
      module.windows[pid][win:id()] = ax
      module.triggerChange(app, win, module.events.created)
    end
  end
end

module._updateAppWindows = function(app, ax)
  if module.windows[app:pid()] == nil then
    module.windows[app:pid()] = {}
  end
  if ax.AXChildren then
    for _, child in ipairs(ax.AXChildren) do
      if child:matchesCriteria("AXWindow") then
        module._addAppWindow(app, child)
      end
    end
  end

  module._addAppWindow(app, ax.AXMainWindow)
  module._addAppWindow(app, ax.AXFocusedWindow)

  for elId, el in pairs(module.windows[app:pid()]) do
    if not el:isValid() then
      module.windows[app:pid()][elId] = nil
      module.triggerChange(app, nil, module.events.closed)
    end
  end
end

module.triggerChange = function(app, win, event)
  local winTitle = ""
  if win then
    winTitle = win:title()
  end
  print(">> " .. event .. ":" .. app:name() .. " -- " .. winTitle)
  for _, fn in ipairs(module._listeners) do
    fn(app, win, event)
    -- hs.timer.doAfter(.01, function() fn(app, win, event) end)
  end
end

module._listeners = {}
module.onChange = function(fn)
  table.insert(module._listeners, fn)
  local win = hs.window.focusedWindow()
  if win ~= nil then
    fn(win:application(), win, module.events.focused)
  end
end

module._watchApp =
  ---@param app hs.application
  function(app)
    if module.apps[app:pid()] ~= nil then
      return
    end
    local ax = hs.axuielement.applicationElement(app)
    -- when the app just launched, we might have to wait for
    -- the next event to setup the observers
    if ax:isValid() then
      print("## watching: " .. app:name())
      module.apps[app:pid()] = app
      module._updateAppWindows(app, ax)
      ---@type hs.axuielement.observer
      local w = hs.axuielement.observer.new(app:pid())
      local addWatcher = function(notif)
        w:addWatcher(ax, notif)
      end
      pcall(addWatcher, "AXFocusedWindowChanged")
      pcall(addWatcher, "AXMainWindowChanged")
      pcall(addWatcher, "AXWindow")
      pcall(addWatcher, "AXResized")
      pcall(addWatcher, "AXMoved")
      pcall(addWatcher, "AXUIElementDestroyed")

      -- w:addWatcher(ax, "AXUIElementDestroyed")
      w:callback(function(_, axel, notif, _notifData)
        if notif == "AXUIElementDestroyed" then
          if not app:focusedWindow() then
            module._updateAppWindows(app, ax)
          end
          return
        end

        if not axel:matchesCriteria("AXWindow") then
          return
        end
        print(hs.inspect(notif))
        local win = axel:asHSWindow()
        -- check for all focus changes, or only for the condition below?
        -- and app:kind() > 0
        if notif == "AXFocusedWindowChanged" then
          module._updateAppWindows(app, ax)
          module.triggerChange(app, win, module.events.focused)
        elseif notif == "AXResized" or notif == "AXMoved" then
          module.triggerChange(app, win, module.events.framed)
        end
      end)
      w:start()
      module.observers[app:pid()] = w
    end
  end

module._updateSpaces = function()
  for _, space in pairs(spaces.layout()[spaces.mainScreenUUID()]) do
    for _, w in pairs(spaces.allWindowsForSpace(space)) do
      module._addAppWindow(w:application(), hs.axuielement.windowElement(w))
    end
  end
end

module._updateRunning = function()
  for _, app in ipairs(hs.application.runningApplications()) do
    module._watchApp(app)
  end
end

module.switcher = function()
  if module._chooser == nil then
    module._chooser = hs.chooser.new(function(choice)
      if choice ~= nil then
        choice.win:focus()
      end
    end):bgDark(true):placeholderText("Switch to Window"):searchSubText(true)
  elseif module._chooser:isVisible() then
    module._chooser:hide()
    return
  end
  local windows = hs.fnutils.map(module.getWindows(), function(win)
    local ret = {
      text = win:title(),
      subText = win:application():title(),
      win = win,
    }
    if win:application():bundleID() then
      ret.image = hs.image.imageFromAppBundle(win:application():bundleID())
    end
    return ret
  end)
  module._chooser:choices(windows):show()
end

module._appWatcher = appw.new(function(appName, event, app)
  if appName == nil then
    appName = ""
  end

  if event == appw.launching then
    return
  end

  if event == appw.terminated then
    module.apps[app:pid()] = nil
    if module.observers[app:pid()] ~= nil then
      module.observers[app:pid()]:stop()
      module.observers[app:pid()] = nil
    end
    return
  end

  if module.apps[app:pid()] == nil then
    module._watchApp(app)
  end

  if event == appw.activated or event == appw.launched then
    local win = app:focusedWindow()
    if win ~= nil then
      module.triggerChange(app, win, module.events.focused)
    end
  end

  if event == appw.hidden then
    module.triggerChange(app, app:mainWindow(), module.events.hidden)
  end
end)

module._spaceWatcher = hs.spaces.watcher.new(module._updateRunning)

module.start = function()
  module._updateSpaces()
  module._spaceWatcher:start()
  module._appWatcher:start()
end

module.start()

return module
