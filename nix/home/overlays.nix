self: super: {
  sumneko-lua-language-server = super.sumneko-lua-language-server.overrideAttrs (
    o: rec {
      version = "2.3.6";

      src = builtins.fetchurl {
        url = "https://github.com/sumneko/vscode-lua/releases/download/v${version}/lua-${version}.vsix";
        sha256 = "1v9gkcqw25jq20drd1r73lh6ciq188nh85acc5yngjkagkzpaka9";
      };

      unpackPhase = ''
        ${super.pkgs.unzip}/bin/unzip $src
      '';
      postPatch = "";

      platform = if super.stdenv.isDarwin then "macOS" else "Linux";

      preBuild = "";
      postBuild = "";
      nativeBuildInputs = [
        super.makeWrapper
      ];

      installPhase = ''
        mkdir -p $out
        cp -r extension $out/extras
        chmod a+x $out/extras/server/bin/$platform/lua-language-server 
        makeWrapper $out/extras/server/bin/$platform/lua-language-server \
          $out/bin/lua-language-server \
          --add-flags "-E -e LANG=en $out/extras/server/main.lua \
          --logpath='~/.cache/sumneko_lua/log' \
          --metapath='~/.cache/sumneko_lua/meta'"
      '';

      meta.platforms = super.lib.platforms.all;
    }
  );
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
  selene = super.stdenv.mkDerivation rec {
    pname = "selene";
    version = "0.14.0";

    src = builtins.fetchurl {
      url = "https://github.com/Kampfkarren/selene/releases/download/${version}/selene-${version}-linux.zip";
      sha256 = "11938xfkap8sjq0qkn8sj3v48a2vqw65gyvbskqzn0ymlrgrfska";
    };

    unpackPhase = ''
      ${super.pkgs.unzip}/bin/unzip $src
    '';

    installPhase = ''
      mkdir -p $out/bin
      chmod a+x ./selene
      cp ./selene $out/bin/selene
    '';
  };
}
