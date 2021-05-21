local spaces = require("hs._asm.undocumented.spaces")

local config = { spacesDelay = 0.3 }

local module = { active = 1, lastMove = 0 }

module.layout = function()
  return spaces.layout()[spaces.mainScreenUUID()]
end

module.set = function(active, force)
  if active ~= module.active or force then
    module.active = active
    print("=== desktop: " .. module.active .. " : " .. module.activeSpace())
    hs.window.filter.switchedToSpace(active)
    for _, fn in ipairs(module._listeners) do
      fn(active)
      -- hs.timer.doAfter(.0, function() fn(active) end)
    end
  end
end

module.spaceId = function(desktop)
  return module.layout()[desktop]
end
module.activeSpace = function()
  return module.spaceId(module.active)
end

module._update = function(force)
  local active = spaces.activeSpace()
  for i, space in ipairs(module.layout()) do
    if space == active then
      module.set(i, force)
    end
  end
end

module._trigger = nil

module._triggerUpdate = function()
  if module._trigger then
    module._trigger:setNextTrigger(config.spacesDelay)
  else
    module._trigger = hs.timer.doAfter(config.spacesDelay, function()
      if spaces.isAnimating() then
        module._trigger:setNextTrigger(config.spacesDelay)
      else
        module._trigger = nil
        module._update()
      end
    end)
  end
end

module.move = function(count)
  module.lastMove = hs.timer.secondsSinceEpoch()
  module.set((((module.active + count) - 1) % #module.layout()) + 1)
end

module.next = function()
  module.move(1)
end
module.previous = function()
  module.move(-1)
end

module._listeners = {}
module.onChange = function(fn)
  table.insert(module._listeners, fn)
  module._update(true)
end

module._watcher = hs.spaces.watcher.new(function()
  module._triggerUpdate()
end)
module._watcher:start()

module.changeTo = function(desktop)
  print("=== changeto " .. desktop)
  module.set(desktop)
  hs.eventtap.keyStroke({ "ctrl" }, string.format("%d", desktop), 1000)
end

module._tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local hasSpaceMods = event:getFlags():containExactly({ "ctrl" })
  local hasMods = event:getFlags():containExactly({ "ctrl", "cmd", "fn" })
  local isUp = event:getKeyCode() == hs.keycodes.map["up"]
  local isDown = event:getKeyCode() == hs.keycodes.map["down"]

  for s = 1, 9 do
    if hasSpaceMods and event:getKeyCode() == hs.keycodes.map[string.format("%d", s)] then
      module.set(s)
    end
  end

  if hasMods and isUp then
    if module.active ~= 1 then
      -- module.changeTo(module.active)
      -- os.execute("/usr/local/bin/yabai -m space --focus prev")
      module.previous()
    end
  end

  if hasMods and isDown then
    if module.active ~= #module.layout() then
      -- os.execute("/usr/local/bin/yabai -m space --focus next")
      module.next()
    end
  end
end)
module._tap:start()

module._update(true)
print("*** Loaded desktop")
return module
