{
  overlay =
    self: super: {
      yabai = super.yabai.overrideAttrs (
        o: rec {
          version = "3.3.10";
          src = builtins.fetchTarball {
            url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
            sha256 = "1z95njalhvyfs2xx6d91p9b013pc4ad846drhw0k5gipvl03pp92";
          };

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share/man/man1/
            cp ./bin/yabai $out/bin/yabai
            cp ./doc/yabai.1 $out/share/man/man1/yabai.1
          '';
        }
      );
    };
}
