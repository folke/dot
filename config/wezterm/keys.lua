local wezterm = require("wezterm")

local act = wezterm.action
local M = {}

M.mod = "SHIFT|SUPER"

M.smart_split = wezterm.action_callback(function(window, pane)
  local dim = pane:get_dimensions()
  if dim.pixel_height > dim.pixel_width then
    window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
  else
    window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
  end
end)

---@param config Config
function M.setup(config)
  config.disable_default_key_bindings = true
  config.keys = {
    -- Scrollback
    { mods = M.mod, key = "k", action = act.ScrollByPage(-0.5) },
    { mods = M.mod, key = "j", action = act.ScrollByPage(0.5) },
    -- New Tab
    { mods = M.mod, key = "t", action = act.SpawnTab("CurrentPaneDomain") },
    -- Splits
    { mods = M.mod, key = "Enter", action = M.smart_split },
    { mods = M.mod, key = "|", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { mods = M.mod, key = "_", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    -- Move Tabs
    { mods = M.mod, key = ">", action = act.MoveTabRelative(1) },
    { mods = M.mod, key = "<", action = act.MoveTabRelative(-1) },
    -- Acivate Tabs
    { mods = M.mod, key = "l", action = act({ ActivateTabRelative = 1 }) },
    { mods = M.mod, key = "h", action = act({ ActivateTabRelative = -1 }) },
    { mods = M.mod, key = "R", action = wezterm.action.RotatePanes("Clockwise") },
    -- show the pane selection mode, but have it swap the active and selected panes
    { mods = M.mod, key = "S", action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }) },
    -- Clipboard
    { mods = M.mod, key = "C", action = act.CopyTo("Clipboard") },
    { mods = M.mod, key = "Space", action = act.QuickSelect },
    { mods = M.mod, key = "X", action = act.ActivateCopyMode },
    { mods = M.mod, key = "f", action = act.Search("CurrentSelectionOrEmptyString") },
    { mods = M.mod, key = "V", action = act.PasteFrom("Clipboard") },
    { mods = M.mod, key = "M", action = act.TogglePaneZoomState },
    { mods = M.mod, key = "p", action = act.ActivateCommandPalette },
    { mods = M.mod, key = "d", action = act.ShowDebugOverlay },
  }

end

return M
