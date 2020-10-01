--- === Seal.plugins.screencapture ===
---
--- A plugin to capture the screen in various ways
local obj = {}
obj.__index = obj
obj.__name = "seal_screencapture"

--- Seal.plugins.screencapture.showPostUI
--- Variable
--- Whether or not to show the screen capture UI in macOS 10.14 or later
obj.showPostUI = true

local static_choices = {
        {
            text = "Capture menu",
            subText = "Show macOS screen capture menu",
            plugin = obj.__name,
            type = "screenUI"
        },
        {
            text = "Capture Screen",
            subText = "Capture the current screen",
            plugin = obj.__name,
            type = "screen"
        },
        {
            text = "Capture Screen to Clipboard",
            subText = "Capture the current screen to the clipboard",
            plugin = obj.__name,
            type = "screen_clipboard"
        },
        {
            text = "Capture Interactive",
            subText = "Draw a rectangle to capture",
            plugin = obj.__name,
            type = "interactive"
        },
        {
            text = "Capture Interactive to Clipboard",
            subText = "Draw a rectangle to capture to the clipboard",
            plugin = obj.__name,
            type = "interactive_clipboard"
        }
}

function obj:commands()
    return {sc = {
        cmd = "sc",
        fn = obj.choicesScreenCaptureCommand,
        name = "Screencapture",
        description = "Capture the screen",
        plugin = obj.__name
        }
    }
end

function obj:bare()
    return nil
end

function obj.choicesScreenCaptureCommand(query)
    local choices = {}

    for k,choice in pairs(static_choices) do
        if string.match(choice["text"]:lower(), query:lower()) then
            table.insert(choices, choice)
        end
    end

    return choices
end

function obj.completionCallback(rowInfo)
    local filename = hs.fs.pathToAbsolute("~").."/Desktop/Screen Capture at "..os.date("!%Y-%m-%d-%T")..".png"
    local args = ""
    local scType = rowInfo["type"]

    if scType == "screen" then
        -- Nothing required here
    elseif scType == "screen_clipboard" then
        args = "-c"
    elseif scType == "interactive" then
        args = "-i"
    elseif scType == "screenUI" then
        args = "-iU"
    elseif scType == "interactive_clipboard" then
        args = "-ci"
    end

    if obj.showPostUI then
        args = args .. "u"
    end

    print(hs.inspect(args))
    hs.task.new("/usr/sbin/screencapture", nil, {args, filename}):start()
end

return obj
