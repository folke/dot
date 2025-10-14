# Optimus GPU Mode Plugin

A DankMaterialShell plugin for managing GPU modes on ASUS laptops with MUX switch support.

## Features

- **Visual Status Indicator**: Color-coded bar widget showing current GPU mode
  - 🔋 Green - Integrated (best battery life)
  - ⚡ Blue - Hybrid (balanced)
  - 🎮 Red - MUX/dGPU Direct (best performance)
- **Quick Mode Switching**: Click to open mode selector with three options
- **Desktop Notifications**: Shows toast notification when mode is changed
- **Pending Mode Display**: Shows configured mode if different from current (requires reboot)
- **Auto-refresh**: Updates status every 30 seconds

## Installation

1. This plugin should already be installed in `~/.config/DankMaterialShell/plugins/OptimusPlugin`
2. Open DMS Settings → Plugins
3. Click "Scan for Plugins"
4. Enable "Optimus GPU Mode"
5. Add `optimusPlugin` to your DankBar widget list (right side recommended)

## Requirements

- `optimus` command in PATH (from ~/dot/bin/optimus)
- ASUS laptop with MUX switch support
- asusd service running

## GPU Modes

### Integrated (🔋)
- iGPU only, dGPU powered off
- Best for battery life
- Lowest power consumption

### Hybrid (⚡)
- Both GPUs active
- iGPU for display, dGPU for rendering
- Use `prime-run` for GPU-accelerated apps
- Balanced performance and battery

### MUX / dGPU Direct (🎮)
- dGPU directly connected to display
- Best gaming performance
- Highest power consumption
- Requires reboot to switch

## Usage

**In the bar**: View current mode and status color
**Click the widget**: Opens mode selector
**Click a mode**: Sets the mode and shows notification (reboot required)

## Configuration

The widget updates automatically from the `optimus` command output. Configure mode persistence through the systemd service.
