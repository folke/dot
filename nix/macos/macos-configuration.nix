{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs;
    [
      # gimp
      # emacsMacport
      # ((emacsPackagesFor emacsMacport).emacsWithPackages(ps: [ ps.vterm ]))
      # (texlive.combine { inherit (texlive) scheme-medium grffile; })
      alacritty
      kitty
      wezterm
      # handbrake
      # vim
      # zathura
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    trustedUsers = [ "@admin" ];
    gc.automatic = true;
    extraOptions = ''
    gc-keep-derivations = true
    gc-keep-outputs = true
    experimental-features = nix-command flakes
  '';
  };

  users.nix.configureBuildUsers = true;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina
  # programs.zsh.enableCompletion = false;
  # programs.zsh.enableBashCompletion = false;
  # programs.zsh.promptInit = "";
  # programs.bash.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
