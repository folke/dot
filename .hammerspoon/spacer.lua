local desktop = require("desktop")
local appw = hs.application.watcher
local spaces = require("hs._asm.undocumented.spaces")

local module = {counts = {}}

module.updateAll = function()
    module.counts = {}
    for _, spaceId in ipairs(desktop.layout()) do module.updateSpace(spaceId) end
end

module.updateSpace = function(spaceId)
    local old = module.counts[spaceId]
    module.counts[spaceId] = 0
    for _, w in pairs(spaces.allWindowsForSpace(spaceId)) do
        if w:subrole() == "AXStandardWindow" then
            module.counts[spaceId] = module.counts[spaceId] + 1
        end
    end
    if module.counts[spaceId] ~= old then
        for _, fn in ipairs(module._listeners) do fn(module.focused) end
    end
end

module.updateActive = function() module.updateSpace(spaces.activeSpace()) end

module.appWatcher = appw.new(
                        function(appName, event, app) module.updateActive() end)
module.appWatcher:start()

module._watcher = hs.spaces.watcher.new(function() module.updateActive() end)
module._watcher:start()

module._listeners = {}
module.onChange = function(fn)
    table.insert(module._listeners, fn)
    fn(module.focused)
end

module.updateAll()

return module
