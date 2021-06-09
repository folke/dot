{ pkgs, config, home-manager, ... }:
let
  util = (import ../util.nix) { config = config; };
  isDarwin = pkgs.stdenv.isDarwin;

  extraHome = if pkgs.stdenv.isDarwin then {
    "./Library/Application Support/lazygit/config.yml".source = util.link "config/lazygit/config.yml";
    ".hammerspoon".source = util.link "hammerspoon";
    ".gnupg/gpg-agent.conf".text =
      "pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
  } else {
    ".gnupg/gpg-agent.conf".text =
      "pinentry-program ${pkgs.pinentry.gnome3}/bin/pinentry";
  };
in
{
  xdg.configFile = util.link-all "config" ".";

  home.file =
    (util.link-all "home" ".") // {
      "dot".source = util.link "";
    } // extraHome;

  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    SHELL = "${pkgs.fish}/bin/fish";
  };
}
