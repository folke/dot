--- === Seal.plugins.urlformats ===
---
--- A plugin to quickly open URLs containing a search/query term
--- This plugin is invoked with the `uf` keyword and requires some configuration, see `:providersTable()`
---
--- The way this works is by defining a set of providers, each of which contains a URL with a `%s` somewhere insert it.
--- When the user types `uf` in Seal, followed by some more characters, those characters will be inserted into the string at the point where the `%s` is.
---
--- By way of an example, you could define a provider with a url like `http://bugs.mycorp.com/showBug?id=%s`, and just need to type `uf 123456` in Seal to get a quick shortcut to open the full URL.
local obj = {}
obj.__index = obj
obj.__name = "seal_urlformats"

obj.providers = {}

-- Example format for providers table
-- {
--     rhbz = {
--         name = "Red Hat Bugzilla",
--         url = "https://bugzilla.redhat.com/show_bug.cgi?id=%s",
--     },
--     lp = {
--         name = "Launchpad Bug",
--         url = "https://launchpad.net/bugs/%s",
--     },
-- }

function obj:commands()
    return {uf = {
        cmd = "uf",
        fn = obj.choicesURLPart,
        name = "URL Formats",
        description = "Open a full URL with a search term",
        plugin = obj.__name
        }
    }
end

function obj:bare()
    return obj.choicesBareURL
end

function obj.choicesBareURL(query)
    local choices = {}
    if string.find(query, "://") ~= nil then
        local scheme = string.sub(query, 1, string.find(query, "://") - 1)
        local handlers = hs.urlevent.getAllHandlersForScheme(scheme)
        for _,bundleID in pairs(handlers) do
            local choice = {}
            local bundleInfo = hs.application.infoForBundleID(bundleID)
            if bundleInfo and bundleInfo["CFBundleName"] then
                choice["text"] = "Open URI with "..bundleInfo["CFBundleName"]
                choice["handler"] = bundleID
                choice["scheme"] = scheme
                choice["type"] = "launch"
                choice["url"] = query
                choice["plugin"] = obj.__name
                choice["image"] = hs.image.imageFromAppBundle(bundleID)
                table.insert(choices, choice)
            end
        end
    end
    return choices
end

function obj.choicesURLPart(query)
    --print("choicesURLPart for: "..query)
    local choices = {}
    for name,data in pairs(obj.providers) do
        local data_url = data["url"]:gsub("([^%%])%%([^s])", "%1%%%%%2")
        local full_url = string.format(data_url, query)
        local url_scheme = string.sub(full_url, 1, string.find(full_url, "://") - 1)
        local choice = {}
        choice["text"] = data["name"]
        choice["subText"] = full_url
        choice["plugin"] = obj.__name
        choice["type"] = "launch"
        choice["url"] = full_url
        choice["scheme"] = url_scheme
        table.insert(choices, choice)
    end
    return choices
end

function obj.completionCallback(rowInfo)
    if rowInfo["type"] == "launch" then
        local handler = nil
        if rowInfo["handler"] == nil then
            handler = hs.urlevent.getDefaultHandler(rowInfo["scheme"])
        else
            handler = rowInfo["handler"]
        end
        hs.urlevent.openURLWithBundle(rowInfo["url"], handler)
    end
end

--- Seal.plugins.urlformats:providersTable(aTable)
--- Method
--- Gets or sets the current providers table
---
--- Parameters:
---  * aTable - An optional table of providers, which must contain the following keys:
---    * name - A string naming the provider, which will be shown in the Seal results
---    * url - A string containing the URL to insert the user's query into. This should contain one and only one `%s`
---
--- Returns:
---  * Either a table of current providers, if no parameter was passed, or nothing if a parmameter was passed.
---
--- Notes:
---  * An example table might look like:
--- ```lua
--- {
---   rhbz = { name = "Red Hat Bugzilla", url = "https://bugzilla.redhat.com/show_bug.cgi?id=%s", },
---   lp = { name = "Launchpad Bug", url = "https://launchpad.net/bugs/%s", },
--- }
--- ```
function obj:providersTable(aTable)
    if aTable then
        self.providers = aTable
    else
        return self.providers
    end
end

return obj
