{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay = {
      type = "github";
      owner = "mjlbach";
      repo = "emacs-overlay";
      ref = "feature/flakes";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      username = "folke";
      yabai = import ./modules/darwin/yabai.nix;
      nixpkgsConfig = with inputs; {
        config = { allowUnfree = true; };
        overlays = [
          yabai.overlay
          inputs.neovim-nightly-overlay.overlay
          inputs.emacs-overlay.overlay
        ];
      };
      homeMamagerCommon = with inputs; {
        imports = [
          ./modules/home
        ];
      };
    in
      {
        darwinConfigurations = {
          macos = darwin.lib.darwinSystem {
            modules = [
              ./modules/darwin
              darwin.darwinModules.simple
              home-manager.darwinModules.home-manager
              {
                nixpkgs = nixpkgsConfig;
                users.users.${username} = {
                  home = "/Users/${username}";
                  name = username;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "orig";
                home-manager.users.${username} = homeMamagerCommon;
              }
            ];
          };
        };
        macos = self.darwinConfigurations.macos.system;
      };
}
