{ config, pkgs, home-manager, ... }:

{
  home.packages = with pkgs; [
    clang-tools # clangd
    neovim-nightly
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.eslint_d
    nodePackages.markdownlint-cli
    nodePackages.pyright
    nodePackages.stylelint
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver
    rnix-lsp
    stylua
    sumneko-lua-language-server
  ];
}
