local spaces = require("hs._asm.undocumented.spaces")

local config = {spacesDelay = 3}

local module = {active = 1, lastMove = 0}

module.layout = function() return spaces.layout()[spaces.mainScreenUUID()] end

module.set = function(active, force)
    if active ~= module.active or force then
        module.active = active
        print("desktop: " .. module.active)
        for _, fn in ipairs(module._listeners) do fn(active) end
    end
end

module.activeSpace = function() return module.layout()[module.active] end

module._update = function(force)
    local active = spaces.activeSpace()
    for i, space in ipairs(module.layout()) do
        if space == active then module.set(i, force) end
    end
end

module._trigger = nil

module._triggerUpdate = function()
    if module._trigger then
        module._trigger:setNextTrigger(config.spacesDelay)
    else
        module._trigger = hs.timer.doAfter(config.spacesDelay, function()
            module._trigger = nil
            module._update()
        end)
    end
end

module.move = function(count)
    module.lastMove = hs.timer.secondsSinceEpoch()
    module.set((((module.active + count) - 1) % #module.layout()) + 1)
end

module.next = function() module.move(1) end
module.previous = function() module.move(-1) end

module._listeners = {}
module.onChange = function(fn)
    table.insert(module._listeners, fn)
    module._update(true)
end

local watcher = hs.spaces.watcher.new(function()
    if hs.timer.secondsSinceEpoch() - module.lastMove > 2 then
        module._update()
    else
        module._triggerUpdate()
    end
end)
watcher:start()
module._update(true)
print("*** Loaded desktop")
return module

