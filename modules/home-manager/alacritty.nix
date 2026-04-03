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
        font = lib.mkForce {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold Italic";
          };
          size = 15;
        };
        window = {
          opacity = lib.mkDefault 0.75;
          startup_mode = "Maximized";
          decorations = "Transparent";
          dynamic_title = true;
          padding = {
            x = 10;
            y = 10;
          };
        };
        general.live_config_reload = true;
        selection.save_to_clipboard = true;
        keyboard.bindings = [
          {
            key = "F11";
            action = "ToggleFullscreen";
          }
          {
            mods = "Control";
            key = "V";
            action = "Paste";
          }
        ];
        colors = lib.mkDefault {
          primary = {
            background = "#191A1C";
            foreground = "#CED0D6";
          };
          normal = {
            black = "#2B2D30";
            red = "#F75464";
            green = "#6AAB73";
            yellow = "#E0BB65";
            blue = "#56A8F5";
            magenta = "#C77DBB";
            cyan = "#2AACB8";
            white = "#DFE1E5";
          };
          bright = {
            black = "#7A7E85";
            red = "#F75464";
            green = "#6AAB73";
            yellow = "#E0BB65";
            blue = "#56A8F5";
            magenta = "#C77DBB";
            cyan = "#2AACB8";
            white = "#DFE1E5";
          };
        };
      };
    };
  };
}
