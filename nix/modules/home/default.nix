{ pkgs, config, home-manager, ... }:
{
  imports = [
    ./dot.nix
    ./cli.nix
    ./neovim.nix
    ./fonts.nix
  ];
}
