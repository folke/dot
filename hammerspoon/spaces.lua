local wb = hs.canvas.windowBehaviors
local desktop = require("desktop")
local running = require("running")
local config = require("config")

-- hs.canvas.useCustomAccessibilitySubrole(false)
local module = { widget = hs.canvas.new({}) }

-- module.windows:setCurrentSpace(false)
module.widget:behavior({ wb.canJoinAllSpaces, wb.stationary })
module.widget:clickActivating(false)
module.widget:level(hs.canvas.windowLevels.dock)
module.widget:_accessibilitySubrole("AXUnknown")

module.update = function()
  if hs.window.focusedWindow() and hs.window.focusedWindow():isFullScreen() then
    module.widget:hide()
    return
  end
  local layout = desktop.layout()

  local spaceW = 51
  local spaceH = 40
  local spaceOffsetY = 9 + config.topbar
  local radius = 12
  -- hs.canvas.disableScreenUpdates()

  module.widget:frame({ x = 5, y = spaceOffsetY, w = spaceW, h = spaceH * #layout })

  module.widget:replaceElements({
    action = "strokeAndFill",
    -- padding = 0,
    type = "rectangle",
    roundedRectRadii = { xRadius = radius, yRadius = radius },
    fillColor = { alpha = 0.2, red = 1, green = 1, blue = 1 },
    strokeColor = { alpha = 0.3, red = 1, green = 1, blue = 1 },
    strokeWidth = 1,
    withShadow = true,
  }, {
    action = "clip",
    type = "rectangle",
    roundedRectRadii = { xRadius = radius, yRadius = radius },
  })

  local spaceY = spaceH / 2
  local currentY = 0

  local windowsPerSpace = running.getWindowsPerSpace()
  for i, spaceId in ipairs(layout) do
    local alpha = 0

    if windowsPerSpace[spaceId] ~= nil then
      for _, _ in pairs(windowsPerSpace[spaceId]) do
        alpha = 1
      end
    end

    local backgroundA = 0
    if i == desktop.active then
      backgroundA = 0.3
    end
    module.widget:appendElements({
      id = i,
      action = "fill",
      type = "rectangle",
      frame = { x = 0, y = currentY, w = spaceW, h = spaceH },
      fillColor = { alpha = backgroundA, red = 1, green = 1, blue = 1 },
      trackMouseUp = true,
      withShadow = false,
    })

    module.widget:appendElements({
      action = "strokeAndFill",
      type = "circle",
      center = { x = spaceW / 2, y = spaceY },
      radius = 7,
      fillColor = { alpha = alpha, red = 1, green = 1, blue = 1 },
      strokeColor = { alpha = 1, red = 1, green = 1, blue = 1 },
      strokeWidth = 2,
      withShadow = false,
    })

    spaceY = spaceY + spaceH
    currentY = currentY + spaceH
  end

  -- hs.canvas.enableScreenUpdates()
  module.widget:show()
end

module.update()

desktop.onChange(module.update)
running.onChange(function(_app, _win, event)
  if event == running.events.closed or event == running.events.created then
    module.update()
  end
end)

module.widget:mouseCallback(function(_, _, id)
  desktop.changeTo(id)
end)

return module
