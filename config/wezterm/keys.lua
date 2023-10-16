local wezterm = require("wezterm")

local act = wezterm.action
local M = {}

M.mod = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "SHIFT|SUPER"

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

  for dir, key in pairs(M.pane_nav) do
    table.insert(config.keys, { key = key, mods = M.pane_nav_mods, action = M.activate_pane(dir) })
  end
end

M.pane_nav = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
}
M.pane_nav_mods = "CTRL"

---@param dir "Right" | "Left" | "Up" | "Down"
function M.activate_pane(dir)
  return wezterm.action_callback(function(window, pane)
    if M.is_nvim(pane) then
      window:perform_action(act.SendKey({ key = M.pane_nav[dir], mods = M.pane_nav_mods }), pane)
    else
      window:perform_action(act.ActivatePaneDirection(dir), pane)
    end
  end)
end

function M.is_nvim(pane)
  -- get_foreground_process_name On Linux, macOS and Windows,
  -- the process can be queried to determine this path. Other operating systems
  -- (notably, FreeBSD and other unix systems) are not currently supported
  return pane:get_foreground_process_name():find("n?vim") ~= nil
  -- return pane:get_title():find("n?vim") ~= nil
end

return M
