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
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixpkgs.config.allowUnfree = true;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/default/configuration.nix
      ];
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/default/home.nix
      ];
    };
  };
}
