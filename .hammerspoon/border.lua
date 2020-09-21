local wb = hs.canvas.windowBehaviors
local desktop = require("desktop")
hs.window.filter.forceRefreshOnSpaceChange = true

local module = {windows = hs.window.filter.new(nil), widget = hs.canvas.new {}}

module.widget:level(hs.canvas.windowLevels.floating)
module.widget:clickActivating(false)
module.widget:_accessibilitySubrole("AXUnknown")
module.widget:behavior({wb.default, wb.transient})
module.windows:setCurrentSpace(true)

function update()
    module.widget:hide()

    local current = desktop.activeSpace()
    local win = hs.window.focusedWindow()
    local found = false
    for _, space in ipairs(win:spaces()) do
        if space == current then found = true end
    end
    if not found then win = nil end

    if win == nil or win:subrole() ~= "AXSystemDialog" then end
    if win ~= nil then
        print(win:title() .. " : " .. win:role() .. " : " .. win:subrole())
    end
    if win ~= nil and win:subrole() == "AXStandardWindow" and win:isVisible() then
        local top_left = win:topLeft()
        local size = win:size()

        module.widget:frame(hs.screen.mainScreen():fullFrame())
        -- 
        -- module.widget:frame(win:frame())

        local radius = 10
        local border = 4
        local offset = 2
        local alpha = .9

        module.widget:replaceElements({
            -- first we start with a rectangle that covers the full canvas
            action = "build",
            frame = {
                x = top_left["x"] - offset,
                y = top_left["y"] - offset,
                h = size['h'] + offset * 2,
                w = size['w'] + offset * 2
            },
            -- padding = 0,
            type = "rectangle",
            roundedRectRadii = {xRadius = radius, yRadius = radius},
            withShadow = false
        }, {
            -- first we start with a rectangle that covers the full canvas
            action = "fill",
            frame = {
                x = top_left["x"] + border - offset,
                y = top_left["y"] + border - offset,
                h = size['h'] - border * 2 + offset * 2,
                w = size['w'] - border * 2 + offset * 2
            },
            -- padding = 0,
            type = "rectangle",
            reversePath = true,
            roundedRectRadii = {
                xRadius = radius - border,
                yRadius = radius - border
            },
            withShadow = false,
            fillColor = {
                alpha = alpha,
                red = 6 / 255,
                green = 182 / 255,
                blue = 239 / 255
            }
        }):show()
    end
end

local delay = 0.2
local movedDelayed = nil

local triggerUpdate = function(win, app, event)
    if movedDelayed then
        movedDelayed:setNextTrigger(delay)
    else
        movedDelayed = hs.timer.doAfter(delay, function()
            movedDelayed = nil
            update()
        end)
    end
end

module.windows:subscribe(hs.window.filter.windowFocused, update)
module.windows:subscribe(hs.window.filter.windowUnfocused, update)
module.windows:subscribe(hs.window.filter.windowCreated, triggerUpdate)
module.windows:subscribe(hs.window.filter.windowMoved, triggerUpdate)
module.windows:subscribe(hs.window.filter.windowHidden, triggerUpdate)
module.windows:subscribe(hs.window.filter.windowDestroyed, triggerUpdate)
module.windows:subscribe(hs.window.filter.windowUnminimized, triggerUpdate)
module.windows:subscribe(hs.window.filter.windowMinimized, triggerUpdate)

desktop.onChange(function() triggerUpdate() end)

-- hs.urlevent.bind("yabaiFocus", function(eventName, params)
--     module.widget:hide()
--     triggerUpdate()
-- end)

triggerUpdate()

return module
