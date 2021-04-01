local module = { pid = nil }
local appw = hs.application.watcher
local spaces = require("hs._asm.undocumented.spaces")

module.appWatcher = appw.new(function(appName, event, app)
  if event == appw.terminated and module.pid == app:pid() then
    module.pid = nil
    print("+++ QuakeMode: exit")
  end

  if appName == "kitty" then
    local win = app:focusedWindow()
    if win and win:title() == "scratchpad" then
      if event == appw.activated or event == appw.launched then
        module.pid = app:pid()
        print("+++ QuakeMode: " .. module.pid)
      end
    end
  end
end)
module.appWatcher:start()

module.toggle = function()
  local app = nil
  if module.pid then app = hs.application.get(module.pid) end
  if app and app:isRunning() then
    if not app:mainWindow() then
      print("kitty: new")
      app:selectMenuItem({ "kitty", "New OS window" })
    elseif app:isFrontmost() then
      print("kitty: hide")
      app:hide()
    else
      print("kitty: activate")
      app:focusedWindow():spacesMoveTo(spaces.activeSpace())
      app:activate()
    end
  else
    print("kitty: launch")

    os.execute(
      "/usr/local/bin/kitty -d ~ --title scratchpad -1 --instance-group scratchpad -o background_opacity=0.95 -o macos_hide_from_tasks=yes -o macos_quit_when_last_window_closed=yes &")
  end
end

return module
