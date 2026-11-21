# Gaze authentication

This role preserves the existing PAM files and applies only the face-authentication
changes needed by this workstation. It does not manage Gaze's GUI settings, enroll
faces/keyring credentials, or overwrite the DMS-managed greetd configuration.

- `system-auth`: Gaze immediately after faillock preauth, before the password stack.
- `sudo` / `polkit-1`: the guarded service-specific entries from Gaze's Arch guide.
- `greetd`: preserve securetty/nologin/shell checks, call `system-auth` as a substack,
  then pass the password/token to GNOME Keyring. Account/session includes stay intact.

The direct `system-auth` reference lets the greeter's shallow PAM detector find
Gaze and start authentication automatically. `substack`, rather than `include`,
ensures a sufficient face match returns to greetd's keyring auth hook.

## Cold-boot readiness

Two systemd drop-ins prevent the greeter's first face-auth attempt from racing
Gaze's model loading:

- `gazed.service.d/readiness.conf`: `Type=dbus`, `BusName=com.gundulabs.Gaze`.
- `greetd.service.d/gaze.conf`: `Wants=gazed.service`, `After=gazed.service`.

Gaze reports ready only when it owns its D-Bus name. `Wants` lets greetd proceed
with password login if Gaze fails. Deployment reloads systemd without restarting
either running service; test automatic face login on the next reboot.

## Running

Keep a root recovery shell open when deploying authentication changes.

```sh
just ansible --tags gaze --check --diff
just ansible --tags gaze
```

The role audits all six relevant auth stacks and prepares/validates all edits
before writing any file. Each changed file is written atomically with a backup;
this is not an atomic transaction across multiple files. Already-configured files
are left untouched. No login manager or desktop service is restarted.

Pending `/etc/pam.d/*.pacnew` files or unfamiliar auth rules stop the role. Review
and merge distro changes manually, then update the layouts in `vars/main.yml` if
needed. In particular, reconsider the flattened greetd auth chain whenever
`system-local-login` or `system-login` changes. Non-auth rules and comments are
preserved, not replaced from a template.

Polkit's PAM file must already exist (Gaze's Arch installer normally creates or
updates it). Unexpected or missing files are not silently replaced.

Gaze's configuration and keyring enrollment are intentionally left to `gaze config`
and `gaze keyring`. In DMS, use system PAM authentication, leave greetd autologin
disabled, and sync the greeter settings. Validate after a fresh face login:

```sh
sudo gaze doctor --verbose
busctl --user get-property org.freedesktop.secrets \
  /org/freedesktop/secrets/collection/login org.freedesktop.Secret.Collection Locked
```

`b false` means the Login keyring is unlocked.

## Tests

```sh
python -m unittest discover -s ansible/roles/gaze/tests
```

The transformation tests use PyYAML, already required by Ansible. They do not
invoke authentication or write system files.
