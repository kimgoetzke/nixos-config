{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;
    systems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Formatter for nix files, available through 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixpkgs.config.allowUnfree = true;

    # NixOS configuration entrypoint, available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/default/configuration.nix
      ];
    };

    # Standalone home-manager configuration entrypoint, available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/default/home.nix
      ];
    };
  };
}
