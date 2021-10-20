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

# Stuff

## Bigger Grub & Console Font

```sh
# Create a font
$ sudo grub2-mkfont -s 32 -o /boot/grub2/DejaVuSansMono.pf2 /usr/share/fonts/dejavu-sans-mono-fonts/DejaVuSansMono.ttf

# edit /etc/default/grub
# add GRUB_FONT=/boot/grub2/DejaVuSansMono.pf2

# rebuild grub
$ sudo grub2-mkconfig -o /etc/grub2-efi.cfg

# edit /etc/vconsole.conf
# add FONT=ter-v32n
```

## Remap keys

- [keyd](https://github.com/rvaiya/keyd)
