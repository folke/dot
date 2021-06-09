{ pkgs, config, home-manager, ... }:

{
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
}
