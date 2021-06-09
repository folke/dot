{ pkgs, config, home-manager, ... }:

{
  home.packages = with pkgs; [
    (
      nerdfonts.override {
        enableWindowsFonts = true;
        fonts = [
          "FiraCode"
          "DejaVuSansMono"
          "JetBrainsMono"
          "FantasqueSansMono"
          "VictorMono"
          "SourceCodePro"
        ];
      }
    )
  ];
}
