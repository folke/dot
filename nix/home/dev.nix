{ pkgs, config, home-manager, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;

  darwinPackages = with pkgs; [
    # git: use system git with keychain integration
    hub
  ];

  linuxPackages = with pkgs; [
    #git
    #hub: use system hub
  ];
in
{
  home.packages = with pkgs; [
    #python39
    #python39Packages.pip
    #python39Packages.pipx
    adoptopenjdk-bin
    gh
    go
    /* hub */
    lua
    nodejs
    nodePackages.pnpm
    nodePackages.yarn
  ] ++ (if isDarwin then darwinPackages else linuxPackages);

}
