--- === Seal.plugins.safari_bookmarks ===
--- Access Safari bookmarks from Seal
---
--- Note: Apple has changed the way Safari stores bookmarks and this plugin no longer works on recent macOS releases.
local obj = {}
obj.__index = obj
obj.__name = "seal_safari_bookmarks"
obj.bookmarkCache = {}
obj.icon = hs.image.iconForFileType("com.apple.safari.bookmark")

--- Seal.plugins.safari_bookmarks.always_open_with_safari
--- Variable
--- If `true` (default), bookmarks are always opened with Safari, otherwise they are opened with the default application using the `/usr/bin/open` command.
obj.always_open_with_safari = true

local modifyNameMap = function(info, add)
    local name
    for _, item in ipairs(info) do
        name = item.kMDItemDisplayName
        if name ~= nil then
            if add then
                obj.bookmarkCache[name] = {
                    url = item.kMDItemURL,
                }
            else
                obj.bookmarkCache[name] = nil
            end
        end
    end
end

local updateNameMap = function(obj, msg, info)
    if info then
        -- all three can occur in either message, so check them all!
        if info.kMDQueryUpdateAddedItems   then modifyNameMap(info.kMDQueryUpdateAddedItems,   true)  end
        if info.kMDQueryUpdateChangedItems then modifyNameMap(info.kMDQueryUpdateChangedItems, true)  end
        if info.kMDQueryUpdateRemovedItems then modifyNameMap(info.kMDQueryUpdateRemovedItems, false) end
    else
        -- shouldn't happen for didUpdate or inProgress
        print("~~~ userInfo from SpotLight was empty for " .. msg)
    end
end

obj.spotlight = hs.spotlight.new():queryString([[ kMDItemContentType = "com.apple.safari.bookmark" ]])
                                  :callbackMessages("didUpdate", "inProgress")
                                  :setCallback(updateNameMap)
                                  :start()

function obj:commands()
    return {}
end

function obj:bare()
    return self.choicesBookmarks
end

function obj.choicesBookmarks(query)
    local choices = {}
    if query == nil or query == "" then
        return choices
    end
    for name,bookmark in pairs(obj.bookmarkCache) do
        url = bookmark["url"]
        if url and (string.match(name:lower(), query:lower()) or string.match(url:lower(), query:lower())) then
            local choice = {}
            local instances = {}
            choice["text"] = name
            choice["subText"] = url
            choice["url"] = url
            choice["image"] = obj.icon
            choice["uuid"] = obj.__name.."__"..name.."__"..url
            choice["plugin"] = obj.__name
            choice["type"] = "openURL"
            table.insert(choices, choice)
        end
    end
    return choices
end

function obj.completionCallback(rowInfo)
   if rowInfo["type"] == "openURL" then
      if obj.always_open_with_safari then
         hs.urlevent.openURLWithBundle(rowInfo["url"], "com.apple.Safari")
      else
         hs.execute(string.format("/usr/bin/open '%s'", rowInfo["url"]))
      end
   end
end

return obj
