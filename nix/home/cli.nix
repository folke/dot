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
    # git: use system git with keychain integration
  ];

  linuxPackages = with pkgs; [
    git
  ];
in
{
  home.packages = with pkgs; [
    python39
    python39Packages.pip
    python39Packages.pipx
    adoptopenjdk-bin
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
    fzf
    fzy
    gh
    go
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

  programs.emacs = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.emacsGcc else pkgs.emacsPgtkGcc;
  };
}
