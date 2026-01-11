{
  config,
  lib,
  ...
}: {
  options = {
    hyprland-hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
  };

  config =
    lib.mkIf config.hyprland-hyprpaper.enable {
      services.hyprpaper = {
        enable = true;
        settings = {
          splash = false;
        };
      };
    }
    // lib.mkIf (!config.hyprland-hyprpaper.enable) {
      stylix.targets.hyprland.hyprpaper.enable = false;
    };
}
