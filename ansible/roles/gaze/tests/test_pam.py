import re
import unittest
from pathlib import Path

import yaml


ROLE = Path(__file__).resolve().parents[1]
LAYOUTS = yaml.safe_load((ROLE / "vars/main.yml").read_text())["gaze_pam_layouts"]


def auth_rules(content):
    lines = [line.split("#", 1)[0].strip() for line in content.splitlines()]
    return [re.sub(r"[ \t]+", " ", line) for line in lines if re.match(r"^-?auth\s+", line)]


def prepare(name, content):
    layout = LAYOUTS[name]
    rules = auth_rules(content)
    if rules not in (layout["original"], layout["configured"]):
        raise ValueError("Unfamiliar authentication layout")
    if rules != layout["configured"]:
        for replacement in layout["replacements"]:
            content = re.sub(replacement["pattern"], replacement["replacement"], content)
    if auth_rules(content) != layout["configured"]:
        raise ValueError("Invalid prepared authentication layout")
    return content


class PamTests(unittest.TestCase):
    def test_original_layouts(self):
        for name, layout in LAYOUTS.items():
            with self.subTest(name=name):
                content = "#%PAM-1.0\n\n" + "\n".join(layout["original"]) + "\n"
                self.assertEqual(auth_rules(prepare(name, content)), layout["configured"])

    def test_preserves_other_sections_and_comments(self):
        for name, layout in LAYOUTS.items():
            with self.subTest(name=name):
                other = "account required pam_access.so\npassword include system-auth\nsession optional pam_new_module.so\n"
                content = "# Vendor comment\n" + "\n".join(layout["original"]) + "\n" + other
                result = prepare(name, content)
                self.assertTrue(result.startswith("# Vendor comment\n"))
                self.assertTrue(result.endswith(other))

    def test_idempotence(self):
        for name, layout in LAYOUTS.items():
            with self.subTest(name=name):
                content = "\n".join(layout["original"]) + "\n"
                result = prepare(name, content)
                self.assertEqual(prepare(name, result), result)

    def test_refuses_new_authentication_checks(self):
        for name, layout in LAYOUTS.items():
            with self.subTest(name=name):
                content = "auth required pam_new_policy.so\n" + "\n".join(layout["configured"]) + "\n"
                with self.assertRaises(ValueError):
                    prepare(name, content)

    def test_refuses_duplicate_gaze(self):
        content = "\n".join(LAYOUTS["system-auth"]["configured"]) + "\nauth sufficient pam_gaze.so\n"
        with self.assertRaises(ValueError):
            prepare("system-auth", content)

    def test_preserves_inline_comments(self):
        content = "\n".join(line + " # vendor note" for line in LAYOUTS["greetd"]["original"]) + "\n"
        result = prepare("greetd", content)
        self.assertEqual(result.count("# vendor note"), content.count("# vendor note"))

    def test_working_host_is_unchanged(self):
        for name in LAYOUTS:
            path = Path("/etc/pam.d") / name
            if not path.exists():
                continue
            with self.subTest(name=name):
                content = path.read_text()
                if auth_rules(content) == LAYOUTS[name]["configured"]:
                    self.assertEqual(prepare(name, content), content)


if __name__ == "__main__":
    unittest.main()
