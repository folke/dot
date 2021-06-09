{ config, pkgs, ... }:

{
  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.skhd.enable = true;

  services.spacebar.enable = true;
  services.spacebar.package = pkgs.spacebar;
}
