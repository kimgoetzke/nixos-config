{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.alacritty;
in {
  options.alacritty = {
    enable = lib.mkEnableOption "Enable Alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = lib.mkForce 0.75;
          startup_mode = "Maximized";
          decorations = "None";
          dynamic_title = true;
          padding = {
            x = 10;
            y = 10;
          };
        };
        live_config_reload = true;
        selection.save_to_clipboard = true;
        colors = {
          primary = {
            background = "#2E3440";
            foreground = "#D8DEE9";
          };
          normal = {
            black = "#3B4252";
            red = "#BF616A";
            green = "#A3BE8C";
            yellow = "#EBCB8B";
            blue = "#81A1C1";
            magenta = "#B48EAD";
            cyan = "#88C0D0";
            white = "#E5E9F0";
          };
          bright = {
            black = "#4C566A";
            red = "#BF616A";
            green = "#A3BE8C";
            yellow = "#EBCB8B";
            blue = "#81A1C1";
            magenta = "#B48EAD";
            cyan = "#8FBCBB";
            white = "#ECEFF4";
          };
        };
      };
    };
  };
}
