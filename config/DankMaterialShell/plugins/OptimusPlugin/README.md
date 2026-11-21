# Cardwire GPU Mode Plugin

DMS bar widget for Cardwire. The directory, component filenames, and `optimusPlugin`
ID are retained so existing bar layouts and plugin settings keep working.

## Behavior

- **Green:** Integrated mode and dGPU asleep (D3hot/D3cold).
- **Theme color:** Hybrid/Smart mode and dGPU asleep.
- **Orange:** dGPU awake, regardless of selected mode.
- **Neutral:** daemon unavailable, query failed, or power state unknown.

The popout shows the GPU name, actual power state, blocked status, and the modes
available on this system: Integrated, Hybrid, and Smart. Changes apply immediately,
without a reboot or logout. Existing GPU applications may retain previously opened
device handles; close/restart them if the GPU does not sleep after blocking it.

The read-only Python helper subscribes to D-Bus mode, block, power, and device
changes using `gdbus monitor`; there is no periodic polling. GPU identity and
available modes are discovered once and cached until a daemon restart or device
change. Changes refresh only the live mode/power/block fields through `busctl`.
The helper never opens NVIDIA devices, reads blocked sysfs paths, or runs
`nvidia-smi`. It reconnects if its monitor exits and reports unknown status while
the daemon is unavailable.

## Setup

Requires `cardwire`, a running `cardwired.service`, Python, systemd's `busctl`, and
GLib's `gdbus` (already installed on the workstation).
Enable **Cardwire GPU Mode** in DMS plugins; existing `optimusPlugin` bar entries
continue to work.

Deploy the workstation's Cardwire integration:

```sh
just ansible --tags cardwire --check --diff
just ansible --tags cardwire
```

Ansible configures Integrated on battery / Hybrid on AC.
The packaged Cardwire service is used without overrides.
It leaves `nvidia-powerd` enabled for Cardwire to manage and disables NVIDIA
persistence. Additional NVIDIA-interface blocking is enabled for the laptop's
single-iGPU/single-NVIDIA topology. Smart is available for manual selection but is
not enabled by default; configure its per-application permissions before relying
on it for games or Ollama.

Keep ASUS firmware in **Hybrid** (`dgpu_disable=0`, `gpu_mux_mode=1`). Cardwire's
Integrated mode blocks applications, not the firmware MUX. Ultimate/dGPU-direct
mode is intentionally not exposed here.

## Testing

```sh
python -m unittest discover -s config/DankMaterialShell/plugins/OptimusPlugin/tests
python config/DankMaterialShell/plugins/OptimusPlugin/cardwire-status.py
```
