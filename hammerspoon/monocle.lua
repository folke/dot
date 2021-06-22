local module = { state = {} }

module.toggle =
  ---@param win hs.window
  function(win)
    local screenFrame = win:screen():frame()

    if win:frame():equals(screenFrame) then
      -- restore state
      if module.state[win:id()] ~= nil then
        win:setFrame(module.state[win:id()])
        module.state[win:id()] = nil
      end
    else
      -- save state and maximise
      module.state[win:id()] = win:frame()
      win:setFrame(screenFrame)
    end
  end

return module
