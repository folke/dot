{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay?rev=2aff1c00dc619b5b8af3dee95461b41f3a6fd7f0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      type = "github";
      owner = "mjlbach";
      repo = "emacs-overlay";
      ref = "feature/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      username = "folke";
      nixpkgsConfig = with inputs; {
        config = { allowUnfree = true; };
        overlays = [
          inputs.neovim-nightly-overlay.overlay
          inputs.emacs-overlay.overlay
          (import ./home/overlays.nix)
        ];
      };
      homeMamagerCommon = with inputs; {
        imports = [
          ./home
        ];
      };
    in
      {
        darwinConfigurations = {
          macos = darwin.lib.darwinSystem {
            modules = [
              ./darwin
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
