{ config, pkgs, home-manager, ... }:

let
  lsp = with pkgs; {
    jsonls = "${nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver";
    # sumnko_lua = "${sumneko-lua-language-server}/bin/";
  };
in
{
  home.packages = with pkgs; [
    neovim-nightly
    nodePackages.pyright
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-json-languageserver
    nodePackages.vscode-html-languageserver-bin
    clang-tools # clangd
    nodePackages.vim-language-server
    sumneko-lua-language-server
    rnix-lsp
  ];

  home.file = builtins.listToAttrs (
    builtins.attrValues (
      builtins.mapAttrs (
        name: value:
          {
            name = ".local/share/nvim/nix-lsp/${name}";
            value = {
              source = value;
            };
          }
      ) lsp
    )
  );
}
