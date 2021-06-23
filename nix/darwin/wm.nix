{ config, pkgs, ... }:

{
  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.skhd.enable = true;

  services.spacebar.enable = false;
  services.spacebar.package = pkgs.spacebar;
}
