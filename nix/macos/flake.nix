{
  description = "Macos system flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs }:
    let
      configuration = import ./macos-configuration.nix;
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake ./modules/examples#darwinConfigurations.simple.system \
      #       --override-input darwin .
      darwinConfigurations.macos = darwin.lib.darwinSystem {
        modules = [ configuration darwin.darwinModules.simple ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."macos".pkgs;
    };
}
