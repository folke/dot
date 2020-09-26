--- === RoundedCorners ===
---
--- Give your screens rounded corners
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/RoundedCorners.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/RoundedCorners.spoon.zip)
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "RoundedCorners"
obj.version = "1.0"
obj.author = "Chris Jones <cmsj@tenshu.net>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.corners = {}
obj.screenWatcher = nil

--- RoundedCorners.allScreens
--- Variable
--- Controls whether corners are drawn on all screens or just the primary screen. Defaults to true
obj.allScreens = true

--- RoundedCorners.radius
--- Variable
--- Controls the radius of the rounded corners, in points. Defaults to 6
obj.radius = 6

--- RoundedCorners.level
--- Variable
--- Controls which level of the screens the corners are drawn at. See `hs.canvas.windowLevels` for more information. Defaults to `screenSaver + 1`
obj.level = hs.canvas.windowLevels["screenSaver"] + 1

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

function obj:init()
    self.screenWatcher = hs.screen.watcher.new(function() self:screensChanged() end)
end

--- RoundedCorners:start()
--- Method
--- Starts RoundedCorners
---
--- Parameters:
---  * None
---
--- Returns:
---  * The RoundedCorners object
---
--- Notes:
---  * This will draw the rounded screen corners and start watching for changes in screen sizes/layouts, reacting accordingly
function obj:start()
    self.screenWatcher:start()
    self:render()
    return self
end

--- RoundedCorners:stop()
--- Method
--- Stops RoundedCorners
---
--- Parameters:
---  * None
---
--- Returns:
---  * The RoundedCorners object
---
--- Notes:
---  * This will remove all rounded screen corners and stop watching for changes in screen sizes/layouts
function obj:stop()
    self.screenWatcher:stop()
    self:deleteAllCorners()
    return self
end

-- Delete all the corners
function obj:deleteAllCorners()
    hs.fnutils.each(self.corners, function(corner) corner:delete() end)
    self.corners = {}
end

-- React to the screens having changed
function obj:screensChanged()
    self:deleteAllCorners()
    self:render()
end

-- Get the screens to draw on, given the user's settings
function obj:getScreens()
    if self.allScreens then
        return hs.screen.allScreens()
    else
        return {hs.screen.primaryScreen()}
    end
end

-- Draw the corners
function obj:render()
    local screens = self:getScreens()
    local radius = self.radius
    hs.fnutils.each(screens, function(screen)
        local screenFrame = screen:fullFrame()
        local cornerData = {
          { frame={x=screenFrame.x, y=screenFrame.y}, center={x=radius,y=radius} },
          { frame={x=screenFrame.x + screenFrame.w - radius, y=screenFrame.y}, center={x=0,y=radius} },
          { frame={x=screenFrame.x, y=screenFrame.y + screenFrame.h - radius}, center={x=radius,y=0} },
          { frame={x=screenFrame.x + screenFrame.w - radius, y=screenFrame.y + screenFrame.h - radius}, center={x=0,y=0} },
        }
        for _,data in pairs(cornerData) do
            self.corners[#self.corners+1] = hs.canvas.new({x=data.frame.x,y=data.frame.y,w=radius,h=radius}):appendElements(
                { action="build", type="rectangle", },
                { action="clip", type="circle", center=data.center, radius=radius, reversePath=true, },
                { action="fill", type="rectangle", frame={x=0, y=0, w=radius, h=radius, }, fillColor={ alpha=1, }},
                { type="resetClip", }
            ):behavior(hs.canvas.windowBehaviors.canJoinAllSpaces):level(self.level):show()
        end
    end)
end

return obj
