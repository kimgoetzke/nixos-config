{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    rofi.enable = lib.mkEnableOption "Enable rofi";
    rofi.package = lib.mkPackageOption pkgs "rofi package" {default = ["rofi-wayland"];};
  };

  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      package = config.rofi.package;
#      theme = with config.lib.stylix.colors.withHashtag lib.mkForce;
#        builtins.toFile "theme.rasi" ''
#          * {
#              font:   "JetBrainsMono Nerd Font Regular 15";
#
#              bg0:     ${base01};
#              bg1:     ${base02};
#              fg0:     ${base04};
#
#              accent-color:     ${base03};
#              urgent-color:     #ffffff;
#
#              background-color:   transparent;
#              text-color:         @fg0;
#
#              margin:     0;
#              padding:    0;
#              spacing:    0;
#          }
#
#          ${builtins.readFile ./../../../assets/configs/hyprland/rofi-theme.rasi}'';
      cycle = true;
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
      ];
      extraConfig = {
        kb-row-up = "Up";
        kb-row-down = "Down";
      };
    };
  };
}
