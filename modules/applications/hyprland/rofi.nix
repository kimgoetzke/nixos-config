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
      theme = lib.mkForce (with config.lib.stylix.colors.withHashtag;
        builtins.toFile "theme.rasi" ''
          * {
              font:               "JetBrains Mono Regular 15";
              bg0:                ${base00}99;
              bg1:                ${base02}99;
              fg0:                ${base03};
              fg1:                ${base0D};
              fg2:                ${base0A};
              fg3:                ${base02};
              regular-color:      ${base06};
              dark-color:         ${base00};
              accent-color:       ${base0F};
              urgent-color:       #ffffff;
              select-color:       ${base0A};
              background-color:   transparent;
              background:         transparent;
              text-color:         @fg0;
              margin:             0;
              padding:            0;
              spacing:            0;
          }
          ${builtins.readFile ./../../../assets/configs/hyprland/rofi-theme.rasi}'');
      cycle = true;
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
        rofi-power-menu
      ];
      extraConfig = {
        kb-row-up = "Up";
        kb-row-down = "Down";
      };
    };
  };
}
