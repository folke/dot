local wb = hs.canvas.windowBehaviors
local desktop = require("desktop")

local module = {windows = hs.window.filter.new(nil), widget = hs.canvas.new {}}

module.widget:behavior({wb.canJoinAllSpaces, wb.stationary})
module.widget:clickActivating(false)
-- module.widget:bringToFront(false)
module.widget:level(hs.canvas.windowLevels.dock)
module.widget:_accessibilitySubrole("AXUnknown")

module.update = function()
    local counts = {}
    local layout = desktop.layout()
    for i, spaceId in ipairs(layout) do counts[spaceId] = 0 end
    for i, win in ipairs(module.windows:getWindows()) do
        for s, spaceId in ipairs(win:spaces()) do
            if counts[spaceId] == nil then counts[spaceId] = 0 end
            counts[spaceId] = counts[spaceId] + 1
        end
    end

    local spaceW = 51
    local spaceH = 40
    local radius = 12
    local current = desktop.activeSpace()
    hs.canvas.disableScreenUpdates()
    module.widget:frame({x = 5, y = 45, w = spaceW, h = spaceH * #layout})
    module.widget:replaceElements({
        action = "strokeAndFill",
        -- padding = 0,
        type = "rectangle",
        roundedRectRadii = {xRadius = radius, yRadius = radius},
        fillColor = {alpha = 0.2, red = 1, green = 1, blue = 1},
        strokeColor = {alpha = 0.3, red = 1, green = 1, blue = 1},
        strokeWidth = 1,
        withShadow = true
    }, {
        action = "clip",
        type = "rectangle",
        roundedRectRadii = {xRadius = radius, yRadius = radius}
    })

    local spaceY = spaceH / 2
    local currentY = 0
    for i, spaceId in ipairs(layout) do
        local alpha = 0
        if counts[spaceId] > 0 then alpha = 1 end

        backgroundA = 0
        if spaceId == current then backgroundA = 0.3 end
        module.widget:appendElements({
            id = i,
            action = "fill",
            type = "rectangle",
            frame = {x = 0, y = currentY, w = spaceW, h = spaceH},
            fillColor = {alpha = backgroundA, red = 1, green = 1, blue = 1},
            trackMouseUp = true,
            withShadow = false
        })

        module.widget:appendElements({
            action = "strokeAndFill",
            type = "circle",
            center = {x = spaceW / 2, y = spaceY},
            radius = 7,
            fillColor = {alpha = alpha, red = 1, green = 1, blue = 1},
            strokeColor = {alpha = 1, red = 1, green = 1, blue = 1},
            strokeWidth = 2,
            withShadow = false
        })

        spaceY = spaceY + spaceH
        currentY = currentY + spaceH
    end

    hs.canvas.enableScreenUpdates()
    module.widget:show()
end

module.update()

desktop.onChange(function() module.update() end)

local delay = 0.1
module.triggerSpaceChange = function()
    if module._trigger then
        module._trigger:setNextTrigger(delay)
    else
        module._trigger = hs.timer.doAfter(delay, function()
            module._trigger = nil
            module.spaceChange()
        end)
    end
end

module.spaceChange = function()
    local d = string.format("%d", desktop.active)
    local spaces = require("hs._asm.undocumented.spaces")
    if spaces.activeSpace() ~= desktop.activeSpace() then
        print("spaceChange: " .. d)
        -- spaces.changeToSpace(desktop.activeSpace(), false)
        hs.eventtap.keyStroke({'ctrl'}, d)
    end
end

hs.hotkey.bind({"cmd", "ctrl"}, "down", "Next Space", function()
    desktop.next()
    module.triggerSpaceChange()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "up", "Previous Space", function()
    desktop.previous()
    module.triggerSpaceChange()
end)

module.widget:mouseCallback(function(_, _, id)
    print("set: " .. id)
    desktop.set(id)
    module.triggerSpaceChange()
end)

return module

