--- ==== Seal.plugins.useractions ====
---
--- Allow accessing user-defined bookmarks and arbitrary actions from Seal.
---

local obj = {}
obj.__index = obj
obj.__basename = "useractions"
obj.__name = "seal_" .. obj.__basename
obj.default_icon = hs.image.imageFromName(hs.image.systemImageNames.ActionTemplate)

--- Seal.plugins.useractions.actions
--- Variable
---
--- A table containing the definitions of static user-defined actions. Each entry is indexed by the name of the entry as it will be shown in the chooser. Its value is a table which can have the following keys (one of `fn` or `url` is required. If both are provided, `url` is ignored):
---  * fn - A function which will be called when the entry is selected. The function receives no arguments.
---  * url - A URL which will be opened when the entry is selected. Can also be non-HTTP URLs, such as `mailto:` or other app-specific URLs.
---  * icon - (optional) An `hs.image` object that will be shown next to the entry in the chooser. If not provided, `Seal.plugins.useractions.default_icon` is used. For `url` bookmarks, it can be set to `"favicon"` to fetch and use the website's favicon.
---  * keyword - (optional) A command by which this action will be invoked, effectively turning it into a Seal command. Any arguments passed to the command will be handled as follows:
---    * For `fn` actions, passed as an argument to the function
---    * For `url` actions, substituted into the URL, taking the place of any occurrences of `${query}`.
---  * hotkey - (optional) A hotkey specification in the form `{ modifiers, key }` by which this action can be invoked.
---
--- Example configuration:
--- ```
--- spoon.Seal:loadPlugins({"useractions"})
--- spoon.Seal.plugins.useractions.actions =
---    {
---       ["Hammerspoon docs webpage"] = {
---          url = "http://hammerspoon.org/docs/",
---          icon = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon),
---          hotkey = { hyper, "h" }
---       },
---       ["Leave corpnet"] = {
---          fn = function()
---             spoon.WiFiTransitions:processTransition('foo', 'corpnet01')
---          end,
---       },
---       ["Arrive in corpnet"] = {
---          fn = function()
---             spoon.WiFiTransitions:processTransition('corpnet01', 'foo')
---          end,
---       },
---       ["Translate using Leo"] = {
---          url = "http://dict.leo.org/ende/index_de.html#/search=${query}",
---          icon = 'favicon',
---          keyword = "leo",
---       },
---       ["Tell me something"] = {
---          keyword = "tellme",
---          fn = function(str) hs.alert.show(str) end,
---       }
--- ```
obj.actions = {}

--- Seal.plugins.useractions.get_favicon
--- Variable
---
--- If `true`, attempt to obtain the favicon for URLs added through the `add` command, and use it in the chooser. Defaults to `true`
obj.get_favicon = true

-- Internal functions for storing/retrieving bookmarks in the settings database.
local getSetting = function(label, default) return hs.settings.get(obj.__name.."."..label) or default end
local setSetting = function(label, value)   hs.settings.set(obj.__name.."."..label, value); return value end

-- Internal variable where the dynamically-added bookmarks are kept
obj.stored_actions = getSetting('stored_actions', {})

-- Internal variable where the merged list of bookmarks/actions is kept
obj.all_actions = nil

function update_all_actions()
   if (obj.all_actions == nil) then
      obj.all_actions = {}
      for k,v in pairs(obj.actions) do obj.all_actions[k] = hs.fnutils.copy(v) end
      for k,v in pairs(obj.stored_actions) do
         obj.all_actions[k] = hs.fnutils.copy(v)
         if v.encoded_icon then
            obj.all_actions[k].icon = hs.image.imageFromURL(v.encoded_icon)
         end
      end
   end
end

function obj:commands()
   local cmds={
      add = {
         cmd = "add",
         fn = obj.choicesAddURLCommand,
         name = "Add URL",
         description = "Add URL to bookmarks",
         plugin = obj.__name
      },
      del = {
         cmd = "del",
         fn = obj.choicesDelURLCommand,
         name = "Delete URL",
         description = "Delete URL from bookmarks",
         plugin = obj.__name
      }
   }
   local hotkeys_def = {}
   local hotkeys_map = {}
   local any_hotkeys = false
   for k,v in pairs(self.actions or {}) do
      if v.keyword and (not cmds[v.keyword]) then
         if v.url ~= nil and v.icon == 'favicon' then
            v.icon = obj.favIcon(v.url)
         end
         cmds[v.keyword] = {
            cmd = v.keyword,
            fn = hs.fnutils.partial(obj.choicesActionKeyword, k, v),
            name = k,
            icon = v.icon,
            plugin = obj.__name
         }
      end
      if v.hotkey then
         local choice = obj.buildChoice(k,v)
         hotkeys_def[k] = hs.fnutils.partial(obj.completionCallback, choice)
         hotkeys_map[k] = v.hotkey
         any_hotkeys = true
      end
   end
   if any_hotkeys then
      hs.spoons.bindHotkeysToSpec(hotkeys_def, hotkeys_map)
   end
   return cmds
end

function obj:bare()
   return self.bareActions
end

function obj.buildChoice(action, v)
   local icon, kind
   local choice=nil
   if type(v) == 'table' then
     if v.fn then
         kind = 'runFunction'
      elseif v.url then
         kind = 'openURL'
         if v.icon == 'favicon' then
            v.icon = obj.favIcon(v.url)
         end
      end
      icon = v.icon or obj.default_icon
      choice = {}
      choice.text = action
      choice.type = kind
      choice.plugin = obj.__name
      choice.image = icon
   end
   return choice
end

function obj.bareActions(query)
   local choices = {}
   if query == nil or query == "" then
      return choices
   end

   update_all_actions()
   obj.seal:refreshCommandsForPlugin(obj.__basename)

   for action,v in pairs(obj.all_actions) do
      if string.match(action:lower(), query:lower()) then
         local choice = obj.buildChoice(action, v)
         if choice then
            table.insert(choices, choice)
         end
      end
   end

   return choices
end

function obj.favIcon(url)
   local query=string.format("http://www.google.com/s2/favicons?domain_url=%s", hs.http.encodeForQuery(url))
   return hs.image.imageFromURL(query)
end

function obj.choicesAddURLCommand(query)
   local choices = {}
   if query == ".*" then
      query = "<url> <name>"
   end
   local url,name = string.match(query, "([^%s]+)%s+(.*)")
   local subtext = ""
   if url then
      subtext = string.format("New bookmark '%s' pointing to %s", name,url)
   end
   local choice = {
      text = "add " .. query,
      subText = subtext,
      url = url,
      name = name,
      plugin = obj.__name,
      type = 'addURL',
   }
   table.insert(choices, choice)
   return choices
end

function obj.choicesDelURLCommand(query)
   local choices = {}
   for k,v in pairs(obj.stored_actions) do
      if string.match(k:lower(), query:lower()) or string.match(v.url:lower(), query:lower()) then
         local choice = {
            text = string.format("delete '%s'", k),
            subText = v.url,
            delKey = k,
            plugin = obj.__name,
            type = 'delURL',
         }
         if v.encoded_icon then
            choice.image = hs.image.imageFromURL(v.encoded_icon)
         end
         table.insert(choices, choice)
      end
   end
   return choices
end

function obj.choicesActionKeyword(action, def, query)
   local choices = {}
   if query == ".*" then
     query = ""
   end
   local choice = {
      text = def.keyword .. " " .. query,
      subText = action,
      actionname = action,
      arg = query,
      plugin = obj.__name,
      image = def.icon,
      type = 'invokeKeyword',
   }
   table.insert(choices, choice)
   return choices
end

function obj.openURL(url)
   hs.execute(string.format("/usr/bin/open '%s'", url))
end

function obj.completionCallback(row)
   update_all_actions()
   if row.type == 'runFunction' then
      local fn = obj.all_actions[row.text].fn
      fn()
   elseif row.type == 'openURL' then
      local url = obj.all_actions[row.text].url
      obj.openURL(url)
   elseif row.type == 'addURL' then
      obj.stored_actions[row.name] = { url = row.url }
      obj.all_actions = nil
      if obj.get_favicon then
         local ico=obj.favIcon(row.url)
         if ico then
            obj.stored_actions[row.name]['encoded_icon'] = ico:encodeAsURLString()
         end
      end
      setSetting('stored_actions', obj.stored_actions)
   elseif row.type == 'delURL' then
      obj.stored_actions[row.delKey] = nil
      obj.all_actions = nil
      setSetting('stored_actions', obj.stored_actions)
   elseif row.type == 'invokeKeyword' then
      if obj.actions[row.actionname].fn then
         obj.actions[row.actionname].fn(row.arg)
      elseif obj.actions[row.actionname].url then
         local url = string.gsub(obj.actions[row.actionname].url, '${query}', row.arg)
         obj.openURL(url)
      end
   end
end

return obj
