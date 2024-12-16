{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nur, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";  # Define the system architecture
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.kosta = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs nur; };  # Pass nur here as well
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          nur.modules.nixos.default
        ];
      };
    };
}

