--- === Seal ===
---
--- Pluggable launch bar
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Seal.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Seal.spoon.zip)
---
--- Seal includes a number of plugins, which you can choose to load (see `:loadPlugins()` below):
---  * apps : Launch applications by name
---  * calc : Simple calculator
---  * rot13 : Apply ROT13 substitution cipher
---  * safari_bookmarks : Open Safari bookmarks (this is broken since at least High Sierra)
---  * screencapture : Lets you take screenshots in various ways
---  * urlformats : User defined URL formats to open
---  * useractions : User defined custom actions
---  * vpn : Connect and disconnect VPNs (currently supports Viscosity and macOS system preferences)A

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Seal"
obj.version = "1.0"
obj.author = "Chris Jones <cmsj@tenshu.net>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.chooser = nil
obj.hotkeyShow = nil
obj.hotkeyToggle = nil
obj.plugins = {}
obj.commands = {}
obj.queryChangedTimer = nil

obj.spoonPath = hs.spoons.scriptPath()

--- Seal.queryChangedTimerDuration
--- Variable
--- Time between the last keystroke and the start of the recalculation of the choices to display, in seconds.
--- Defaults to 0.02s (20ms).
obj.queryChangedTimerDuration = 0.02

--- Seal.plugin_search_paths
--- Variable
--- List of directories where Seal will look for plugins. Defaults to `~/.hammerspoon/seal_plugins/` and the Seal Spoon directory.
obj.plugin_search_paths = { hs.configdir .. "/seal_plugins", obj.spoonPath }

--- Seal:refreshCommandsForPlugin(plugin_name)
--- Method
--- Refresh the list of commands provided by the given plugin.
---
--- Parameters:
---  * plugin_name - the name of the plugin. Should be the name as passed to `loadPlugins()` or `loadPluginFromFile`.
---
--- Returns:
---  * The Seal object
---
--- Notes:
---  * Most Seal plugins expose a static list of commands (if any), which are registered at the time the plugin is loaded. This method is used for plugins which expose a dynamic or changing (e.g. depending on configuration) list of commands.
function obj:refreshCommandsForPlugin(plugin_name)
   plugin = self.plugins[plugin_name]
   if plugin.commands then
      for cmd,cmdInfo in pairs(plugin:commands()) do
         if not self.commands[cmd] then
            print("-- Adding Seal command: "..cmd)
            self.commands[cmd] = cmdInfo
         end
      end
   end
   return self
end

--- Seal:refreshAllCommands()
--- Method
--- Refresh the list of commands provided by all the currently loaded plugins.
---
--- Parameters:
---  * None
---
--- Returns:
---  * The Seal object
---
--- Notes:
---  * Most Seal plugins expose a static list of commands (if any), which are registered at the time the plugin is loaded. This method is used for plugins which expose a dynamic or changing (e.g. depending on configuration) list of commands.
function obj:refreshAllCommands()
   for p, _ in pairs(self.plugins) do
      self:refreshCommandsForPlugin(p)
   end
   return self
end

--- Seal:loadPluginFromFile(plugin_name, file)
--- Method
--- Loads a plugin from a given file
---
--- Parameters:
---  * plugin_name - the name of the plugin, without "seal_" at the beginning or ".lua" at the end
---  * file - the file where the plugin code is stored.
---
--- Returns:
---  * The Seal object if the plugin was successfully loaded, `nil` otherwise
---
--- Notes:
---  * You should normally use `Seal:loadPlugins()`. This method allows you to load plugins
---    from non-standard locations and is mostly a development interface.
---  * Some plugins may immediately begin doing background work (e.g. Spotlight searches)
function obj:loadPluginFromFile(plugin_name, file)
   local f,err = loadfile(file)
   if f~= nil then
      local plugin = f()
      plugin.seal = self
      self.plugins[plugin_name] = plugin
      self:refreshCommandsForPlugin(plugin_name)
      return self
   else
      return nil
   end
end

--- Seal:loadPlugins(plugins)
--- Method
--- Loads a list of Seal plugins
---
--- Parameters:
---  * plugins - A list containing the names of plugins to load
---
--- Returns:
---  * The Seal object
---
--- Notes:
---  * The plugins live inside the Seal.spoon directory
---  * The plugin names in the list, should not have `seal_` at the start, or `.lua` at the end
---  * Some plugins may immediately begin doing background work (e.g. Spotlight searches)
function obj:loadPlugins(plugins)
    self.chooser = hs.chooser.new(self.completionCallback)
    self.chooser:choices(self.choicesCallback)
    self.chooser:queryChangedCallback(self.queryChangedCallback)

    for k,plugin_name in pairs(plugins) do
       local loaded=nil
       print("-- Loading Seal plugin: " .. plugin_name)
       for _,dir in ipairs(self.plugin_search_paths) do
          if obj.plugins[plugin_name] == nil then
             local file = dir .. "/seal_" .. plugin_name .. ".lua"
             loaded = (self:loadPluginFromFile(plugin_name, file) ~= nil)
          end
       end
       if (not loaded) then
          hs.showError(string.format("Error: could not find Seal plugin %s in any of the load paths %s", plugin_name, hs.inspect(self.plugin_search_paths)))
       end
    end
    return self
end

--- Seal:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for Seal
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following (optional) items:
---   * show - This will cause Seal's UI to be shown
---   * toggle - This will cause Seal's UI to be shown or hidden depending on its current state
---
--- Returns:
---  * The Seal object
function obj:bindHotkeys(mapping)
    if (self.hotkeyShow) then
        self.hotkeyShow:delete()
    end
    if (self.hotkeyToggle) then
        self.hotkeyToggle:delete()
    end

    if mapping["show"] ~= nil then
        local showMods = mapping["show"][1]
        local showKey = mapping["show"][2]
        self.hotkeyShow = hs.hotkey.new(showMods, showKey, function() self:show() end)
    end
    if mapping["toggle"] ~= nil then
        local toggleMods = mapping["toggle"][1]
        local toggleKey = mapping["toggle"][2]
        self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self:toggle() end)
    end

    return self
end

--- Seal:start()
--- Method
--- Starts Seal
---
--- Parameters:
---  * None
---
--- Returns:
---  * The Seal object
function obj:start()
    print("-- Starting Seal")
    if self.hotkeyShow then
        self.hotkeyShow:enable()
    end
    if self.hotkeyToggle then
        self.hotkeyToggle:enable()
    end
    return self
end

--- Seal:stop()
--- Method
--- Stops Seal
---
--- Parameters:
---  * None
---
--- Returns:
---  * The Seal object
---
--- Notes:
---  * Some Seal plugins will continue performing background work even after this call (e.g. Spotlight searches)
function obj:stop()
    print("-- Stopping Seal")
    self.chooser:hide()
    if self.hotkeyShow then
        self.hotkeyShow:disable()
    end
    if self.hotkeyToggle then
        self.hotkeyToggle:disable()
    end
    return self
end

--- Seal:show(query)
--- Method
--- Shows the Seal UI
---
--- Parameters:
---  * query - An optional string to pre-populate the query box with
---
--- Returns:
---  * None
---
--- Notes:
---  * This may be useful if you wish to show Seal in response to something other than its hotkey
function obj:show(query)
    self.chooser:show()
    if query then self.chooser:query(query) end
    return self
end

--- Seal:toggle(query)
--- Method
--- Shows or hides the Seal UI
---
--- Parameters:
---  * query - An optional string to pre-populate the query box with
---
--- Returns:
---  * None
function obj:toggle(query)
    if self.chooser:isVisible() then
        self.chooser:hide()
    else
        self:show(query)
    end
    return self
end

function obj.completionCallback(rowInfo)
    if rowInfo == nil then
        return
    end
    if rowInfo["type"] == "plugin_cmd" then
        obj.chooser:query(rowInfo["cmd"])
        return
    end
    for k,plugin in pairs(obj.plugins) do
        if plugin.__name == rowInfo["plugin"] then
            plugin.completionCallback(rowInfo)
            break
        end
    end
end

function obj.choicesCallback()
    -- TODO: Sort each of these clusters of choices, alphabetically
    choices = {}
    query = obj.chooser:query()
    cmd = nil
    query_words = {}
    if query == "" then
        return choices
    end
    for word in string.gmatch(query, "%S+") do
        if cmd == nil then
            cmd = word
        else
            table.insert(query_words, word)
        end
    end
    query_words = table.concat(query_words, " ")
    -- First get any direct command matches
    for command,cmdInfo in pairs(obj.commands) do
        cmd_fn = cmdInfo["fn"]
        if cmd:lower() == command:lower() then
            if (query_words or "") == "" then
                query_words = ".*"
            end
            fn_choices = cmd_fn(query_words)
            if fn_choices ~= nil then
                for j,choice in pairs(fn_choices) do
                    table.insert(choices, choice)
                end
            end
        end
    end
    -- Now get any bare matches
    for k,plugin in pairs(obj.plugins) do
        bare = plugin:bare()
        if bare then
            for i,choice in pairs(bare(query)) do
                table.insert(choices, choice)
            end
        end
    end
    -- Now add in any matching commands
    -- TODO: This only makes sense to do if we can select the choice without dismissing the chooser, which requires changes to HSChooser
    for command,cmdInfo in pairs(obj.commands) do
        if string.match(command, query) and #query_words == 0 then
            choice = {}
            choice["text"] = cmdInfo["name"]
            choice["subText"] = cmdInfo["description"]
            choice["type"] = "plugin_cmd"
            table.insert(choices,choice)
        end
    end

    return choices
end

function obj.queryChangedCallback(query)
    if obj.queryChangedTimer then
        obj.queryChangedTimer:stop()
    end
    obj.queryChangedTimer = hs.timer.doAfter(obj.queryChangedTimerDuration,
                                             function() obj.chooser:refreshChoicesCallback() end)
end

return obj

--- === Seal.plugins ===
---
--- Various APIs for Seal plugins

-- This isn't really shown, but it's necessary to force Seal.plugins.html to render
--- Seal.plugins
--- Constant
--- This is a table containing all of the loaded plugins for Seal. You should interact with it only via documented API that the plugins expose.
