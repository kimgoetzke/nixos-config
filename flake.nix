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
    # TODO: Find a way to source 'hostName' from user.nix or at least just define it in one place
    hostName = "blade"; # Must be the same 'userSettings.hostName' in 'user.nix'
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
        ./hosts/${hostName}/configuration.nix
        stylix.nixosModules.stylix
      ];
    };

    # Use standalone home-manager configuration with 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/${hostName}/home.nix
      ];
    };
  };
}
