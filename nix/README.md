# Dot Files

## Restoring dotfiles

### Install Single-User Nix

```shell
# Linux
$ sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Macos
$ sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume

# Install Nix Unstable
$ nix-env -f '<nixpkgs>' -iA nixUnstable

# Clone dotfiles
$ git clone git@github.com:folke/dot.git

# Install dotfiles
$ cd ~/dot/nix
$ ./install macos
```
