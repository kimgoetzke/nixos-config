{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";

    # A Nix flake that can be used to automate the generation and integration of AMD microcode updates
    ucodenix.url = "github:e-tho/ucodenix/a32504d15405dbf2d80c55e1a6307ef0f9d6d2bf";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-nord-theme = {
      url = "github:EliverLara/firefox-nordic-theme";
      flake = false;
    };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    yazi-plugins-wl-clipboard = {
      url = "github:grappas/wl-clipboard.yazi";
      flake = false;
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    textfox.url = "github:adriankarlen/textfox";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ucodenix,
    nixvim,
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
          ucodenix.nixosModules.ucodenix
          nixvim.nixosModules.nixvim
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
          }
        ];
      };
    };
  };
}
