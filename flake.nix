{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgss-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";

    stylix.url = "github:danth/stylix";

    firefox-nord-theme = {
      url = "github:EliverLara/firefox-nordic-theme";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Use formatter with 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixpkgs.config.allowUnfree = true;

    # Use NixOS configuration with 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/default/configuration.nix
        stylix.nixosModules.stylix
      ];
    };

    # Use standalone home-manager configuration with 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/default/home.nix
      ];
    };
  };
}
