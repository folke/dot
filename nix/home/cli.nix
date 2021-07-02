{ pkgs, config, home-manager, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;

  darwinPackages = with pkgs; [
    coreutils
    gnused
    curl
    wget
    fontconfig
    kitty
    less
    rsync
    # git: use system git with keychain integration
  ];

  kmonad = (import ./kmonad.nix) pkgs;

  linuxPackages = with pkgs; [
#   git
  kmonad
  ];
in
{
  home.packages = with pkgs; [
    alacritty
    aria2
    as-tree
    aspell
    bat
    bandwhich
    bottom
    broot
    ctop
    delta
    du-dust
    exa
    fd
    direnv
    nix-direnv
    fzf
    fzy
    grc
    glow
    gnupg
    gnused
    htop
    httpie
    hyperfine
    jq
    languagetool
    lazydocker
    lazygit
    manix
    mdcat
    nix-index
    nnn
    ncdu
    nixUnstable
    osmium-tool
    pass
    pfetch
    procs
    qemu
    ranger
    ripgrep
    shellcheck
    shfmt
    starship
    tealdeer
    tmux
    tmuxinator
    tokei
    weechat
    wezterm
    zoxide
  ] ++ (if isDarwin then darwinPackages else linuxPackages);

  programs.direnv.enable = true;
  programs.direnv.nix-direnv = {
    enable = true;
    enableFlakes = true;
  };

  programs.emacs = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.emacsGcc else pkgs.emacsPgtkGcc;
  };
}
