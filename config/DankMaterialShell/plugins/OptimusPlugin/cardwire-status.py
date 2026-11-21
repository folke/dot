#!/usr/bin/python
"""Read Cardwire's API without opening GPU device nodes or blocked sysfs files."""

import json
import subprocess


SERVICE = "org.opengamingcollective.cardwire"
ROOT = "/org/opengamingcollective/cardwire"
MODES = {0: "integrated", 1: "hybrid", 2: "manual", 3: "smart"}


def busctl(*args):
    result = subprocess.run(
        ["busctl", "--system", "--timeout=2", "--json=short", *args],
        capture_output=True,
        text=True,
        check=True,
        timeout=3,
    )
    return json.loads(result.stdout)["data"]


def snapshot():
    mode = MODES.get(busctl("get-property", SERVICE, ROOT, SERVICE + ".Mode", "Mode"), "unknown")
    available = busctl("call", SERVICE, ROOT, SERVICE + ".Mode", "AvailableModes")[0]
    result = subprocess.run(
        ["cardwire", "list", "--json"], capture_output=True, text=True, check=True, timeout=3
    )
    devices = json.loads(result.stdout)
    discrete = sorted(
        (gpu for gpu in devices.values() if gpu["discrete"] and not gpu["default"]),
        key=lambda gpu: (not gpu.get("nvidia", False), gpu["pci"]),
    )
    if not discrete:
        raise ValueError("No non-default discrete GPU found")
    gpu = discrete[0]
    power = busctl(
        "call", SERVICE, f"{ROOT}/Gpu/{gpu['id']}", SERVICE + ".Gpu", "PowerState"
    )[0].strip()
    normalized = power.lower()
    if normalized in ("d3cold", "d3hot"):
        state = "asleep"
    elif normalized in ("d0", "d1", "d2"):
        state = "awake"
    else:
        state = "unknown"
    return {
        "ok": True,
        "mode": mode,
        "modes": [MODES[value] for value in available if value in MODES and value != 2],
        "gpu": gpu["name"],
        "pci": gpu["pci"],
        "blocked": gpu["blocked"],
        "power": power,
        "state": state,
    }


def main():
    try:
        status = snapshot()
    except (OSError, subprocess.SubprocessError, ValueError, KeyError, TypeError, IndexError) as error:
        status = {"ok": False, "error": str(error), "state": "unknown"}
    print(json.dumps(status))


if __name__ == "__main__":
    main()
