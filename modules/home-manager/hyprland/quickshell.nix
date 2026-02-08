{
  inputs,
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    hyprland-quickshell.enable = lib.mkEnableOption "Enable Quickshell, a fancy bar/panel for Hyprland";
  };

  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf config.hyprland-quickshell.enable {
    home.file.".config/noctalia/settings.json" = lib.mkForce {
      source = ./../../../assets/configs/noctalia/settings.json;
    };

    home.file.".config/noctalia/colors.json" = lib.mkForce {
      source = ./../../../assets/configs/noctalia/colors.json;
    };

    home.file.".config/noctalia/plugins" = lib.mkForce {
      source = ./../../../assets/configs/noctalia/plugins;
      recursive = true;
    };
  };
}
