{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-versions"
      "nextdns/homebrew-tap"
    ];

    brews = [
      "fnm"
      "mas"
      "nextdns"
      "efm-langserver"
    ];

    casks = [
      "alfred"
      "avibrazil-rdm"
      "bitwarden"
      "discord"
      "docker-edge"
      "element"
      "emby-server"
      "expressvpn"
      "firefox-developer-edition"
      "github"
      "google-backup-and-sync"
      "hammerspoon"
      "iterm2"
      "messenger"
      "minecraft"
      "miniconda"
      "mullvadvpn-beta"
      "notion"
      "obs"
      "qutebrowser"
      "slack"
      "spotify"
      "steam"
      "twitch"
      "ubersicht"
      "visual-studio-code-insiders"
      "vlc"
      "webcatalog"
      "whatsapp"
      "zoom"
      # "wezterm-nightly"
    ];
  };
}
