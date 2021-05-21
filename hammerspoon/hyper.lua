local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function()
  hyper:enter()
end
hyper.released = function()
  hyper:exit()
end

-- Set the key you want to be HYPER to F19 in karabiner or keyboard
-- Bind the Hyper key to the hammerspoon modal
hs.hotkey.bind({}, "F18", hyper.pressed, hyper.released)

hyper.bindApp = function(mods, key, app)
  local fn = function()
    hs.application.launchOrFocus(app)
  end
  if type(app) == "function" then
    fn = app
  end
  hyper:bind(mods, key, fn)
end

return hyper
