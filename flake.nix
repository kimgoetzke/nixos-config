{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-nord-theme = {
      url = "github:EliverLara/firefox-nordic-theme";
      flake = false;
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
    inherit (nixpkgs) lib;
    systems = ["x86_64-linux"];
    userSettings = import ./users/user.nix {inherit inputs lib;};
    specialArgs = {inherit inputs outputs userSettings;};
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    nixpkgs.config.allowUnfree = true;

    # Use formatter with 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Use NixOS configuration with 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/${userSettings.hostName}/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
  };
}
