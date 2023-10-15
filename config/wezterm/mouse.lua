local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function make_mouse_binding(dir, streak, button, mods, action)
  return {
    event = { [dir] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end

---@param config Config
function M.setup(config)
  config.alternate_buffer_wheel_scroll_speed = 1
  config.bypass_mouse_reporting_modifiers = require("keys").mod
  config.mouse_bindings = {
    -- {
    --   event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    --   mods = "NONE",
    --   action = act.ScrollByLine(-1),
    -- },
    -- {
    --   event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    --   mods = "NONE",
    --   action = act.ScrollByLine(1),
    -- },
    -- make_mouse_binding(
    --   "Up",
    --   1,
    --   "Left",
    --   "NONE",
    --   wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
    -- ),
    -- make_mouse_binding(
    --   "Up",
    --   1,
    --   "Left",
    --   "SHIFT",
    --   wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
    -- ),
    -- make_mouse_binding("Up", 1, "Left", "ALT", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
    -- make_mouse_binding(
    --   "Up",
    --   1,
    --   "Left",
    --   "SHIFT|ALT",
    --   wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
    -- ),
    -- make_mouse_binding("Up", 2, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
    -- make_mouse_binding("Up", 3, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
  }
end

return M
