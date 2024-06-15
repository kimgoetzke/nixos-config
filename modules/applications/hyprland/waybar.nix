{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    waybar.enable = lib.mkEnableOption "Enable Waybar";
  };

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      style = with config.lib.stylix.colors.withHashtag;
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};
          @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};
        ''
        + builtins.readFile ./../../../assets/configs/hyprland/waybar-style.css;
      settings = {
        bar = {
          layer = "top";
          height = 40;
          spacing = 8;
          margin-top = 20;
          margin-left = 20;
          margin-right = 20;
          margin-down = 5;
          modules-left = ["hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = ["network" "memory" "backlight" "pulseaudio" "hyprland/language" "tray" "battery"];
          "hyprland/language" = {
            format = "{} <span font-family='Material Design Icons,JetBrainsMono Nerd Font' rise='-1000' size='medium'>󰌌</span>";
            format-en = "EN";
          };
          "tray" = {
            spacing = 10;
          };
          "clock" = {
            format = "{:%H:%M  <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰅐</span>}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%d %h %Y  <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰃮</span>}";
            on-click = "killall calcure || alacritty -t calcure -e calcure;sudo ydotool click 0xc1";
          };
          "memory" = {
            format = "{}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font'></span>";
            on-click = "killall btop || alacritty -t btop -e btop;sudo ydotool click 0xc1";
          };
          "backlight" = {
            format = "{percent}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>{icon}</span>";
            format-icons = ["󰃞" "󰃟" "󰃠"];
            tooltip-format = "Backlight at {percent}%";
          };
          "battery" = {
            "states" = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>{icon}</span>";
            format-charging = "{capacity}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰂄</span>";
            format-plugged = "{capacity}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font'></span>";
            format-alt = "<span font-family='Material Design Icons,JetBrainsMono Nerd Font'>{icon}</span>";
            format-icons = ["󱃍" "󰁼" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };
          "network" = {
            interface = "wlp2*";
            format-wifi = "{essid} ({signalStrength}%) <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰤨</span>";
            format-ethernet = "{ipaddr}/{cidr} <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰈀</span>";
            tooltip-format = "{ifname} via {gwaddr} <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰩟</span>";
            format-linked = "{ifname} (No IP) <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰩟</span>";
            format-disconnected = "<span font-family='Material Design Icons,JetBrainsMono Nerd Font'>󰤫</span>";
            on-click = "killall connman-gtk || connman-gtk;sudo ydotool click 0xc1";
          };
          "pulseaudio" = {
            format = "{volume}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font'>{icon}</span> {format_source}";
            format-bluetooth = "{volume}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font' rise='-2000' font-size='x-large'>󰥰</span> {format_source}";
            format-bluetooth-muted = "<span font-family='Material Design Icons' rise='-2000' font-size='x-large'>󰟎 </span>{format_source}";
            format-muted = "<span font-family='Material Design Icons,JetBrainsMono Nerd Font' rise='-2000' font-size='x-large'>󰝟</span> {format_source}";
            format-source = "{volume}% <span font-family='Material Design Icons,JetBrainsMono Nerd Font' rise='-2000' font-size='x-large'>󰍬</span>";
            format-source-muted = "<span font-family='Material Design Icons,JetBrainsMono Nerd Font' rise='-2000' font-size='x-large'>󰍭</span>";
            on-click = "killall bluetuith || alacritty -t blue -e bluetuith; sudo ydotool click 0xc1";
            "format-icons" = {
              headphone = "󰋋";
              hands-free = "󰋋";
              headset = "󰋋";
              phone = "";
              portable = "";
              car = "";
              muted-icon = "󰝟";
              default = ["󰕿" "󰖀" "󰕾"];
            };
          };
        };
      };
    };
  };
}
