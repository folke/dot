{ pkgs, config, ... }:
let
  username = "folke";
in
{
  imports = [
    ./wm.nix
    ./homebrew.nix
  ];

  environment.shells = with pkgs; [ bashInteractive fish zsh dash ];

  environment.systemPackages = with pkgs;
    [
      fish
    ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = false;
  nix = {
    package = pkgs.nixFlakes;
    trustedUsers = [ "@admin" ];
    gc.automatic = true;
    gc.user = "folke";
    extraOptions = ''
      gc-keep-derivations = true
      gc-keep-outputs = true
      experimental-features = nix-command flakes
      substituters = https://cache.nixos.org https://cache.nixos.org/ https://nix-community.cachix.org https://mjlbach.cachix.org https://gccemacs-darwin.cachix.org
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI= gccemacs-darwin.cachix.org-1:E0Q1uCBvxw58kfgoWtlletUjzINF+fEIkWknAKBnPhs=
    '';
  };

  nixpkgs.config.allowUnsupportedSystem = false;

  # add user packages to Applications
  system.build.applications = pkgs.lib.mkForce (
    pkgs.buildEnv {
      name = "applications";
      paths = config.environment.systemPackages ++ config.home-manager.users.${username}.home.packages;
      pathsToLink = "/Applications";
    }
  );

  # copy apps so spotlight will pick them up
  system.activationScripts.applications.text =
    pkgs.lib.mkForce (
      ''
        rm -rf ~/Applications/Nix\ Apps
        mkdir -p ~/Applications/Nix\ Apps
        for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
          src="$(/usr/bin/stat -f%Y "$app")"
          cp -raL "$src" ~/Applications/Nix\ Apps
        done
      ''
    );

  users.nix.configureBuildUsers = false;

  system.stateVersion = 4;
}
