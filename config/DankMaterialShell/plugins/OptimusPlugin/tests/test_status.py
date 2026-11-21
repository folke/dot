import contextlib
import importlib.util
import io
import json
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch


spec = importlib.util.spec_from_file_location("cardwire_status", Path(__file__).parents[1] / "cardwire-status.py")
status = importlib.util.module_from_spec(spec)
spec.loader.exec_module(status)

DEVICES = {
    "0": {"id": 0, "name": "AMD", "pci": "0000:65:00.0", "discrete": False, "default": True},
    "7": {"id": 7, "name": "NVIDIA", "pci": "0000:64:00.0", "discrete": True, "default": False, "nvidia": True, "blocked": True},
}


class StatusTests(unittest.TestCase):
    def snapshot(self, mode=0, power="D3cold\n", devices=None):
        process = subprocess.CompletedProcess([], 0, json.dumps(DEVICES if devices is None else devices))
        with patch.object(status, "busctl", side_effect=[mode, [[0, 1, 3]], [power]]) as bus, patch.object(status.subprocess, "run", return_value=process):
            result = status.snapshot()
            self.assertEqual(bus.call_args.args[2], status.ROOT + "/Gpu/7")
            return result

    def test_discovers_gpu_id(self):
        result = self.snapshot()
        self.assertEqual(result["gpu"], "NVIDIA")
        self.assertEqual(result["mode"], "integrated")
        self.assertEqual(result["modes"], ["integrated", "hybrid", "smart"])
        self.assertEqual(result["state"], "asleep")

    def test_awake_even_when_integrated(self):
        self.assertEqual(self.snapshot(power="D0")["state"], "awake")

    def test_hybrid_and_smart(self):
        self.assertEqual(self.snapshot(mode=1)["mode"], "hybrid")
        self.assertEqual(self.snapshot(mode=3)["mode"], "smart")

    def test_unknown_power_is_not_awake(self):
        for power in ["", "Unknown", "unavailable"]:
            with self.subTest(power=power):
                self.assertEqual(self.snapshot(power=power)["state"], "unknown")

    def test_d3hot_is_asleep(self):
        self.assertEqual(self.snapshot(power="D3hot")["state"], "asleep")

    def test_daemon_failure_produces_unknown_status(self):
        with patch.object(status, "snapshot", side_effect=subprocess.TimeoutExpired("busctl", 3)), contextlib.redirect_stdout(io.StringIO()) as output:
            status.main()
        result = json.loads(output.getvalue())
        self.assertFalse(result["ok"])
        self.assertEqual(result["state"], "unknown")

    def test_missing_discrete_gpu(self):
        process = subprocess.CompletedProcess([], 0, json.dumps({"0": DEVICES["0"]}))
        with patch.object(status, "busctl", side_effect=[0, [[0, 1, 3]]]), patch.object(status.subprocess, "run", return_value=process):
            with self.assertRaisesRegex(ValueError, "No non-default"):
                status.snapshot()


if __name__ == "__main__":
    unittest.main()
