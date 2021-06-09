{ pkgs, config, home-manager, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;

  darwinPackages = with pkgs; [
    coreutils
    gnused
    curl
    wget
    fontconfig
    less
    rsync
  ];
in
{
  home.packages = with pkgs; [
    python39
    adoptopenjdk-bin
    alacritty
    aria2
    as-tree
    aspell
    bat
    bandwhich
    bottom
    ctop
    delta
    du-dust
    exa
    fd
    direnv
    fzf
    fzy
    gh
    go
    git
    grc
    glow
    gnupg
    gnused
    htop
    httpie
    hub
    hyperfine
    jq
    kitty
    languagetool
    lazydocker
    lazygit
    lua
    manix
    mdcat
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
  ] ++ (if isDarwin then darwinPackages else []);

  programs.emacs = {
    enable = true;
    # package = if pkgs.stdenv.isDarwin then pkgs.nixos-unstable.emacsGcc else pkgs.nixos-unstable.emacsPgtkGcc;
    package = if pkgs.stdenv.isDarwin then pkgs.emacsGcc else pkgs.emacsPgtkGcc;
    # (emacsPackagesFor emacsMacport).emacsWithPackages(ps: [ ps.seq ])
    # extraPackages = (epkgs: [ epkgs.vterm ] );
  };
}
