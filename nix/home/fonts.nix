{ pkgs, config, home-manager, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (
      nerdfonts.override {
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

  fonts.fontconfig.enable = true;
}
