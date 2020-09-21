filter = hs.window.filter
filter.setLogLevel(10)
filter.default:subscribe(filter.windowFocused, function() print("foo") end)

