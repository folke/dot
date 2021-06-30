{ pkgs, config, home-manager, ... }:
{
  imports = [
    ./dot.nix
    ./cli.nix
    ./dev.nix
    ./neovim.nix
    ./fonts.nix
  ];
}
