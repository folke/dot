--- === hs._asm.undocumented.spaces ===
---
--- These functions utilize private API's within the OS X internals, and are known to have unpredictable behavior under Mavericks and Yosemite when "Displays have separate Spaces" is checked under the Mission Control system preferences.
---

local USERDATA_TAG = "hs._asm.undocumented.spaces"
-- some of the commands can really get you in a bit of a fix, so this file will be mostly wrappers and
-- predefined, common actions.
local internal = require(USERDATA_TAG..".internal")
local module   = {}

local basePath = package.searchpath(USERDATA_TAG, package.path)
if basePath then
    basePath = basePath:match("^(.+)/init.lua$")
    if require"hs.fs".attributes(basePath .. "/docs.json") then
        require"hs.doc".registerJSONFile(basePath .. "/docs.json")
    end
end

-- local log = require("hs.logger").new(USERDATA_TAG, require"hs.settings".get(USERDATA_TAG .. ".logLevel") or "warning")

local screen      = require("hs.screen")
local window      = require("hs.window")
local settings    = require("hs.settings")
local inspect     = require("hs.inspect")
local application = require("hs.application")

-- private variables and methods -----------------------------------------

-- flag is checked to see if certain functions are called from module or from module.raw to prevent doing
-- dangerous/unexpected/unknown things unless explicitly enabled
local _BE_DANGEROUS_FLAG_ = false

local _kMetaTable = {}
_kMetaTable._k = {}
_kMetaTable.__index = function(obj, key)
        if _kMetaTable._k[obj] then
            if _kMetaTable._k[obj][key] then
                return _kMetaTable._k[obj][key]
            else
                for k,v in pairs(_kMetaTable._k[obj]) do
                    if v == key then return k end
                end
            end
        end
        return nil
    end
_kMetaTable.__newindex = function(obj, key, value)
        error("attempt to modify a table of constants",2)
        return nil
    end
_kMetaTable.__pairs = function(obj) return pairs(_kMetaTable._k[obj]) end
_kMetaTable.__tostring = function(obj)
        local result = ""
        if _kMetaTable._k[obj] then
            local width = 0
            for k,v in pairs(_kMetaTable._k[obj]) do width = width < #k and #k or width end
            for k,v in pairs(_kMetaTable._k[obj]) do
                result = result..string.format("%-"..tostring(width).."s %s\n", k, tostring(v))
            end
        else
            result = "constants table missing"
        end
        return result
    end
_kMetaTable.__metatable = _kMetaTable -- go ahead and look, but don't unset this

local _makeConstantsTable = function(theTable)
    local results = setmetatable({}, _kMetaTable)
    _kMetaTable._k[results] = theTable
    return results
end

local reverseWithoutSystemSpaces = function(list)
    local results = {}
    for i,v in ipairs(list) do
        if internal.spaceType(v) ~= internal.types.system then
            table.insert(results, 1, v)
        end
    end
    return results
end

local isSpaceSafe = function(spaceID, func)
    func = func or "undocumented.spaces"
    if not _BE_DANGEROUS_FLAG_ then
        local t = internal.spaceType(spaceID)
        if t ~= internal.types.fullscreen and t ~= internal.types.tiled and t ~= internal.types.user then
            _BE_DANGEROUS_FLAG_ = false
            error(func..":must be user-created or fullscreen application space", 3)
        end
    end
    _BE_DANGEROUS_FLAG_ = false
    return spaceID
end

local screenMT = hs.getObjectMetatable("hs.screen")
local windowMT = hs.getObjectMetatable("hs.window")

-- Public interface ------------------------------------------------------

module.types = _makeConstantsTable(internal.types)
module.masks = _makeConstantsTable(internal.masks)

-- replicate legacy functions

--- hs._asm.undocumented.spaces.count() -> number
--- Function
--- LEGACY: The number of spaces you currently have.
---
--- Notes:
---  * this function may go away in a future update
---
---  * this functions is included for backwards compatibility.  It is not recommended because it worked by indexing the spaces ignoring that fullscreen applications are included in the list twice, and only worked with one monitor.  Use `hs._asm.undocumented.spaces.query` or `hs._asm.undocumented.spaces.spacesByScreenUUID`.
module.count = function()
    return #reverseWithoutSystemSpaces(module.query(internal.masks.allSpaces))
end

--- hs._asm.undocumented.spaces.currentSpace() -> number
--- Function
--- LEGACY: The index of the space you're currently on, 1-indexed (as usual).
---
--- Notes:
---  * this function may go away in a future update
---
---  * this functions is included for backwards compatibility.  It is not recommended because it worked by indexing the spaces, which can be rearranged by the operating system anyways.  Use `hs._asm.undocumented.spaces.query` or `hs._asm.undocumented.spaces.spacesByScreenUUID`.
module.currentSpace = function()
    local theSpaces = reverseWithoutSystemSpaces(module.query(internal.masks.allSpaces))
    local currentID = internal.query(internal.masks.currentSpaces)[1]
    for i,v in ipairs(theSpaces) do
        if v == currentID then return i end
    end
    return nil
end

--- hs._asm.undocumented.spaces.moveToSpace(number)
--- Function
--- LEGACY: Switches to the space at the given index, 1-indexed (as usual).
---
--- Notes:
---  * this function may go away in a future update
---
---  * this functions is included for backwards compatibility.  It is not recommended because it was never really reliable and worked by indexing the spaces, which can be rearranged by the operating system anyways.  Use `hs._asm.undocumented.spaces.changeToSpace`.
module.moveToSpace = function(whichIndex)
    local theID = internal.query(internal.masks.allSpaces)[whichIndex]
    if theID then
        internal._changeToSpace(theID, false)
        return true
    else
        return false
    end
end

--- hs._asm.undocumented.spaces.isAnimating([screen]) -> bool
--- Function
--- Returns the state of space changing animation for the specified monitor, or for any monitor if no parameter is specified.
---
--- Parameters:
---  * screen - an optional hs.screen object specifying the specific monitor to check the animation status for.
---
--- Returns:
---  * a boolean value indicating whether or not a space changing animation is currently active.
---
--- Notes:
---  * This function can be used in `hs.eventtap` based space changing functions to determine when to release the mouse and key events.
---
---  * This function is also added to the `hs.screen` object metatable so that you can check a specific screen's animation status with `hs.screen:spacesAnimating()`.
module.isAnimating = function(...)
    local args = table.pack(...)
    if args.n == 0 then
        local isAnimating = false
        for i,v in ipairs(screen.allScreens()) do
            isAnimating = isAnimating or internal.screenUUIDisAnimating(internal.UUIDforScreen(v))
        end
        return isAnimating
    elseif args.n == 1 then
        return internal.screenUUIDisAnimating(internal.UUIDforScreen(args[1]))
    else
        error("isAnimating:invalid argument, none or hs.screen object expected", 2)
    end
end

module.spacesByScreenUUID = function(...)
    local args = table.pack(...)
    if args.n == 0 or args.n == 1 then
        local masks = args[1] or internal.masks.allSpaces
        local theSpaces = module.query(masks)
        local holding = {}
        for i,v in ipairs(theSpaces) do
            local myScreen = internal.spaceScreenUUID(v) or "screenUndefined"
            if not holding[myScreen] then holding[myScreen] = {} end
            table.insert(holding[myScreen], v)
        end
        return holding
    else
        error("spacesByScreenUUID:invalid argument, none or integer expected", 2)
    end
end

-- need to make sure its a user accessible space
module.changeToSpace = function(...)
    local args = table.pack(...)
    if args.n == 1 or args.n == 2 then
        local spaceID = isSpaceSafe(args[1], "changeToSpace")
        if type(args[2]) == "boolean" then resetDock = args[2] else resetDock = true end
        local fromID, uuid = 0, internal.spaceScreenUUID(spaceID)
        for i, v in ipairs(module.query(internal.masks.currentSpaces)) do
            if uuid == internal.spaceScreenUUID(v) then
                fromID = v
                break
            end
        end
        if fromID == 0 then
            error("changeToSpace:unable to identify screen for space id "..spaceID, 2)
        end

        -- this is where you could do some sort of animation with the transform functions
        -- may add that in the future

        internal.disableUpdates()
        for i,v in ipairs(module.query(internal.masks.currentOSSpaces)) do
            if internal.spaceScreenUUID(v) == targetUUID then
                internal.spaceLevel(v, internal.spaceLevel(v) + 1)
            end
        end
        internal.spaceLevel(spaceID, internal.spaceLevel(spaceID) + 1)
        -- doesn't seem to be necessary, _changeToSpace does it for us, though you would need
        -- it if you did any animation for the switch
--         internal.showSpaces(spaceID)
        internal._changeToSpace(spaceID)
        internal.hideSpaces(fromID)
        internal.spaceLevel(spaceID, internal.spaceLevel(spaceID) - 1)
        for i,v in ipairs(module.query(internal.masks.currentOSSpaces)) do
            if internal.spaceScreenUUID(v) == targetUUID then
                internal.spaceLevel(v, internal.spaceLevel(v) - 1)
            end
        end
        internal.enableUpdates()

        if resetDock then hs.execute("killall Dock") end
    else
        error("changeToSpace:invalid argument, spaceID and optional boolean expected", 2)
    end
    return internal.query(internal.masks.currentSpaces)
end

module.mainScreenUUID = function(...)
    local UUID = internal.mainScreenUUID(...)
    if #UUID ~= 36 then -- on one screen machines, it returns "Main" which doesn't work for spaceCreate
        UUID = internal.spaceScreenUUID(internal.activeSpace())
    end
    return UUID
end

-- -need a way to determine/specify which screen
module.createSpace = function(...)
    local args = table.pack(...)
    if args.n <= 2 then
        local uuid, resetDock
        if type(args[1])     == "string"  then uuid      = args[1]     else uuid = module.mainScreenUUID() end
        if type(args[#args]) == "boolean" then resetDock = args[#args] else resetDock = true end
        local newID = internal.createSpace(uuid)
        if resetDock then hs.execute("killall Dock") end
        return newID
    else
        error("createSpace:invalid argument, screenUUID and optional boolean expected", 2)
    end
end

-- -need to make sure no windows are only there
-- -need to make sure its a user window
-- ?check for how to do tiled/fullscreen?
module.removeSpace = function(...)
    local args = table.pack(...)
    if args.n == 1 or args.n == 2 then
        local _Are_We_Being_Dangerous_ = _BE_DANGEROUS_FLAG_
        local spaceID = isSpaceSafe(args[1], "removeSpace")
        local resetDock
        if type(args[2]) == "boolean" then resetDock = args[2] else resetDock = true end

        if internal.spaceType(spaceID) ~= internal.types.user then
            error("removeSpace:you can only remove user created spaces", 2)
        end
        for i,v in ipairs(module.query(internal.masks.currentSpaces)) do
            if spaceID == v then
                error("removeSpace:you can't remove one of the currently active spaces", 2)
            end
        end
        local targetUUID = internal.spaceScreenUUID(spaceID)
        local sameScreenSpaces = module.spacesByScreenUUID()[targetUUID]
        local userSpacesCount = 0
        for i,v in ipairs(sameScreenSpaces) do
            if internal.spaceType(v) == internal.types.user then
                userSpacesCount = userSpacesCount + 1
            end
        end
        if userSpacesCount < 2 then
            error("removeSpace:there must be at least one user space on each screen", 2)
        end

        -- Probably not necessary, with above checks, but if I figure out how to safely
        -- "remove" fullscreen/tiled spaces, I may remove them for experimenting
        _BE_DANGEROUS_FLAG_ = _Are_We_Being_Dangerous_
        -- check for windows which need to be moved
        local theWindows = {}
        for i, v in ipairs(module.allWindowsForSpace(spaceID)) do if v:id() then table.insert(theWindows, v:id()) end end

        -- get id of screen to move them to
        local baseID = 0
        for i,v in ipairs(module.query(internal.masks.currentSpaces)) do
            if internal.spaceScreenUUID(v) == targetUUID then
                baseID = v
                break
            end
        end

        for i,v in ipairs(theWindows) do
        -- only add windows that exist in only one place
            if #internal.windowsOnSpaces(v) == 1 then
                internal.windowsAddTo(v, baseID)
            end
        end


        internal.windowsRemoveFrom(theWindows, spaceID)
        internal._removeSpace(spaceID)
        if resetDock then hs.execute("killall Dock") end
    else
        error("removeSpace:invalid argument, spaceID and optional boolean expected", 2)
    end
end

module.allWindowsForSpace = function(...)
    local args = table.pack(...)
    if args.n == 1 then
        local ok, spaceID = pcall(isSpaceSafe, args[1], "allWindowsForSpace")
        if not ok then
            if internal.spaceName(args[1]) == "dashboard" then spaceID = args[1] else error(spaceID, 2) end
        end
        local isCurrent, windowIDs = false, {}
        for i,v in ipairs(module.query(internal.masks.currentSpaces)) do
            if v == spaceID then
                isCurrent = true
                break
            end
        end
        if isCurrent then
            windowIDs = window.allWindows()
        else
            local targetUUID = internal.spaceScreenUUID(spaceID)
            local baseID = 0
            for i,v in ipairs(module.query(internal.masks.currentSpaces)) do
                if internal.spaceScreenUUID(v) == targetUUID then
                    baseID = v
                    break
                end
            end
            internal.disableUpdates()
            for i,v in ipairs(module.query(internal.masks.currentOSSpaces)) do
                if internal.spaceScreenUUID(v) == targetUUID then
                    internal.spaceLevel(v, internal.spaceLevel(v) + 1)
                end
            end
            internal.spaceLevel(baseID, internal.spaceLevel(baseID) + 1)

            internal._changeToSpace(spaceID)
            windowIDs = window.allWindows()
            internal.hideSpaces(spaceID)
            internal._changeToSpace(baseID)

            internal.spaceLevel(baseID, internal.spaceLevel(baseID) - 1)
            for i,v in ipairs(module.query(internal.masks.currentOSSpaces)) do
                if internal.spaceScreenUUID(v) == targetUUID then
                    internal.spaceLevel(v, internal.spaceLevel(v) - 1)
                end
            end
            internal.enableUpdates()

        end
        local realWindowIDs = {}
        for i,v in ipairs(windowIDs) do
            if v:id() then
                for j,k in ipairs(internal.windowsOnSpaces(v:id())) do
                    if k == spaceID then
                        table.insert(realWindowIDs, v)
                    end
                end
            end
        end
        windowIDs = realWindowIDs
        return windowIDs
    else
        error("allWindowsForSpace:invalid argument, spaceID expected", 2)
    end
end

module.windowOnSpaces = function(...)
    local args = table.pack(...)
    if args.n == 1 then
        windowIDs = internal.windowsOnSpaces(args[1])
        return windowIDs
    else
        error("windowOnSpaces:invalid argument, windowID expected", 2)
    end
end

module.moveWindowToSpace = function(...)
    local args = table.pack(...)
    if args.n == 2 then
        local windowID = args[1]
        local spaceID  = isSpaceSafe(args[2], "moveWindowToSpace")
        local currentSpaces = internal.windowsOnSpaces(windowID)
        if #currentSpaces == 0 then
            error("moveWindowToSpace:no spaceID found for window", 2)
        elseif #currentSpaces > 1 then
            error("moveWindowToSpace:window on multiple spaces", 2)
        end
        if currentSpaces[1] ~= spaceID then
            internal.windowsAddTo(windowID, spaceID)
            internal.windowsRemoveFrom(windowID, currentSpaces[1])
        end
        return internal.windowsOnSpaces(windowID)[1]
    else
        error("moveWindowToSpace:invalid argument, windowID and spaceID expected", 2)
    end
end

module.layout = function()
    local results = {}
    for i,v in ipairs(internal.details()) do
        local screenID = v["Display Identifier"]
        if screenID == "Main" then
            screenID = module.mainScreenUUID()
        end
        results[screenID] = {}
        for j,k in ipairs(v.Spaces) do
            table.insert(results[screenID], k.ManagedSpaceID)
        end
    end
    return results
end

module.query = function(...)
    local args = table.pack(...)
    if args.n <= 2 then
        local mask, flatten = internal.masks.allSpaces, true
        if type(args[1]) == "number"      then mask = args[1] end
        if type(args[#args]) == "boolean" then flatten = args[#args] end
        local results = internal.query(mask)
        if not flatten then
            return results
        else
            local userWants, seen = {}, {}
            for i, v in ipairs(results) do
                if not seen[v] then
                    seen[v] = true
                    table.insert(userWants, v)
                end
            end
            return userWants
        end
    else
        error("query:invalid argument, mask and optional boolean expected", 2)
    end
end

-- map the basic functions to the main module spaceID

module.screensHaveSeparateSpaces = internal.screensHaveSeparateSpaces
module.activeSpace               = internal.activeSpace
module.spaceType                 = internal.spaceType
module.spaceName                 = internal.spaceName
module.spaceOwners               = internal.spaceOwners
module.spaceScreenUUID           = internal.spaceScreenUUID

-- generate debugging information
module.debug = {}

module.debug.layout = function(...) return inspect(internal.details(...)) end

module.debug.report = function(...)
    local mask = 7                      -- user accessible spaces
    local _ = table.pack(...)[1]
    if type(_) == "boolean" and _ then
        mask = 31                       -- I think this gets user and "system" spaces like expose, etc.
    elseif type(_) == "boolean" then
        mask = 917519                   -- I think this gets *everything*, but it may change as I dig
    elseif type(_) == "number" then
        mask = _                        -- user specified mask
    elseif table.pack(...).n ~= 0 then
        error("debugReport:bad mask type provided, expected number", 2)
    end

    local list, report = module.query(mask), ""

    report = "Screens have separate spaces: "..tostring(internal.screensHaveSeparateSpaces()).."\n"..
             "Spaces for mask "..string.format("0x%08x", mask)..": "..(inspect(internal.query(mask)):gsub("%s+"," "))..
             "\n\n"

    for i,v in ipairs(list) do
        report = report..module.debug.spaceInfo(v).."\n"
    end

    -- see if mask included any of the users accessible spaces flag
    if (mask & (1 << 2) ~= 0) then report = report.."\nLayout: "..inspect(internal.details()).."\n" end
    return report
end

module.debug.spaceInfo = function(v)
    local results =
        "Space: "..v.." ("..inspect(internal.spaceName(v))..")\n"..
        "    Type:      "..(module.types[internal.spaceType(v)] and module.types[internal.spaceType(v)] or "-- unknown --")
                                        .." ("..internal.spaceType(v)..")\n"..
        "    Level:     ".. internal.spaceLevel(v).."\n"..
        "    CompatID:  ".. internal.spaceCompatID(v).."\n"..
        "    Screen:    ".. inspect(internal.spaceScreenUUID(v)).."\n"..
        "    Shape:     "..(inspect(internal.spaceShape(v)):gsub("%s+"," ")).."\n"..
        "    MShape:    "..(inspect(internal.spaceManagedShape(v)):gsub("%s+"," ")).."\n"..
        "    Transform: "..(inspect(internal.spaceTransform(v)):gsub("%s+"," ")).."\n"..
        "    Values:    "..(inspect(internal.spaceValues(v)):gsub("%s+"," ")).."\n"..
        "    Owners:    "..(inspect(internal.spaceOwners(v)):gsub("%s+"," ")).."\n"
    if #internal.spaceOwners(v) > 0 then
        local apps = {}
        for i,v in ipairs(internal.spaceOwners(v)) do
            table.insert(apps, (application.applicationForPID(v) and
                                application.applicationForPID(v):title() or "n/a"))
        end
        results = results.."          :    "..(inspect(apps):gsub("%s+"," ")).."\n"
    end
    return results
end

-- extend built in modules

screenMT.__index.spaces          = function(obj) return module.spacesByScreenUUID()[internal.UUIDforScreen(obj)] end
screenMT.__index.spacesUUID      = internal.UUIDforScreen
screenMT.__index.spacesAnimating = function(obj) return internal.screenUUIDisAnimating(internal.UUIDforScreen(obj)) end

windowMT.__index.spaces          = function(obj) return obj:id() and internal.windowsOnSpaces(obj:id()) or nil end
windowMT.__index.spacesMoveTo    = function(obj, ...)
    if obj:id() then
        module.moveWindowToSpace(obj:id(), ...)
        return obj
    end
    return nil
end

-- add raw subtable if the user has enabled it

if settings.get("_ASMundocumentedSpacesRaw") then
    module.raw = internal
    module.raw.changeToSpace = function(...)
        _BE_DANGEROUS_FLAG_ = true
        local result = module.changeToSpace(...)
        _BE_DANGEROUS_FLAG_ = false -- should be already, but just in case
        return result
    end
    module.raw.removeSpace = function(...)
        _BE_DANGEROUS_FLAG_ = true
        local result = module.changeToSpace(...)
        _BE_DANGEROUS_FLAG_ = false -- should be already, but just in case
        return result
    end
    module.raw.allWindowsForSpace = function(...)
        _BE_DANGEROUS_FLAG_ = true
        local result = module.allWindowsForSpace(...)
        _BE_DANGEROUS_FLAG_ = false -- should be already, but just in case
        return result
    end
end

-- Return Module Object --------------------------------------------------


return module
