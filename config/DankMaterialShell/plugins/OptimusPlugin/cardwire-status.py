#!/usr/bin/python
"""Read Cardwire's API without opening GPU device nodes or blocked sysfs files."""

import json
import signal
import subprocess
import sys


SERVICE = "org.opengamingcollective.cardwire"
ROOT = "/org/opengamingcollective/cardwire"
MODES = {0: "integrated", 1: "hybrid", 2: "manual", 3: "smart"}
ERRORS = (OSError, subprocess.SubprocessError, ValueError, KeyError, TypeError, IndexError, RuntimeError)


def busctl(*args):
    result = subprocess.run(
        ["busctl", "--system", "--auto-start=no", "--timeout=2", "--json=short", *args],
        capture_output=True,
        text=True,
        check=True,
        timeout=3,
    )
    return json.loads(result.stdout)["data"]


def snapshot(cache=None):
    if cache is None:
        cache = {}
    mode = MODES.get(busctl("get-property", SERVICE, ROOT, SERVICE + ".Mode", "Mode"), "unknown")
    if not cache:
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
        cache.update(gpu=discrete[0], modes=[MODES[value] for value in available if value in MODES and value != 2])
    gpu = cache["gpu"]
    path = f"{ROOT}/Gpu/{gpu['id']}"
    power = busctl("call", SERVICE, path, SERVICE + ".Gpu", "PowerState")[0].strip()
    blocked = busctl("get-property", SERVICE, path, SERVICE + ".Gpu", "Block")
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
        "modes": cache["modes"],
        "gpu": gpu["name"],
        "pci": gpu["pci"],
        "blocked": blocked,
        "power": power,
        "state": state,
    }


def read_status(cache=None):
    try:
        return snapshot(cache)
    except ERRORS as error:
        if cache is not None:
            cache.clear()
        return {"ok": False, "error": str(error), "state": "unknown"}


def watch():
    monitor = subprocess.Popen(
        ["gdbus", "monitor", "--system", "--dest", SERVICE],
        stdout=subprocess.PIPE,
        text=True,
    )
    cache = {}
    previous = None
    try:
        for line in monitor.stdout:
            # The owner announcement follows subscription and also reports daemon
            # restarts. Ignore unrelated signals such as per-process block logging.
            if line.startswith("The name " + SERVICE + " "):
                cache.clear()
            elif line.startswith(ROOT):
                member = line.split(": ", 1)[-1].split(" ", 1)[0]
                if member in ("org.freedesktop.DBus.ObjectManager.InterfacesAdded", "org.freedesktop.DBus.ObjectManager.InterfacesRemoved"):
                    cache.clear()
                elif member not in ("org.freedesktop.DBus.Properties.PropertiesChanged", SERVICE + ".Gpu.PowerStateChanged"):
                    continue
            else:
                continue
            current = read_status(cache)
            if current != previous:
                print(json.dumps(current), flush=True)
                previous = current
        raise RuntimeError("D-Bus signal monitor disconnected")
    finally:
        monitor.terminate()
        try:
            monitor.wait(timeout=2)
        except subprocess.TimeoutExpired:
            monitor.kill()
            monitor.wait()


def main():
    if "--watch" not in sys.argv[1:]:
        print(json.dumps(read_status()))
        return 0

    def stop(signum, frame):
        raise SystemExit(0)

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    try:
        watch()
    except ERRORS as error:
        print(json.dumps({"ok": False, "error": str(error), "state": "unknown"}), flush=True)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
