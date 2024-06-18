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
          spacing = 10;
          margin-top = 20;
          margin-left = 20;
          margin-right = 20;
          margin-down = 0;
          modules-left = ["group/hardware"];
          modules-center = ["hyprland/workspaces"];
          modules-right = ["tray" "wlr/taskbar" "clock" "battery"];
          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 14;
            icon-theme = "Numix-Circle";
            tooltip-format = "{name}";
            on-click = "activate";
            on-click-middle = "close";
          };
          "hyprland/language" = {
            format = "{} 󰌌";
            format-en = "EN";
          };
          "tray" = {
            spacing = 10;
          };
          "clock" = {
            format = "{:%H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%d %h %Y  󰃮}";
          };
          "group/hardware" = {
            orientation = "horizontal";
            modules = [
              "cpu"
              "memory"
              "network"
              "backlight"
              "pulseaudio"
            ];
          };
          "cpu" = {
            interval = 10;
            format = "{}% ";
            max-length = 10;
          };
          "memory" = {
            format = "{used:0.1f}G/{total:0.1f}G ";
          };
          "backlight" = {
            format = "{percent}% {icon}";
            format-icons = ["󰃞" "󰃟" "󰃠"];
            tooltip-format = "Backlight at {percent}%";
          };
          "battery" = {
            "states" = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% 󰂄";
            format-plugged = "{capacity}% ";
            format-icons = ["" "" "" "" ""];
          };
          "network" = {
            interface = "wlp2*";
            format-wifi = "{essid} ({signalStrength}%) 󰤨";
            format-ethernet = "{ipaddr}/{cidr} 󰈀";
            tooltip-format = "{ifname} via {gwaddr} 󰩟";
            format-linked = "{ifname} (No IP) 󰩟";
            format-disconnected = "󰤫";
            on-click = "killall connman-gtk || connman-gtk;sudo ydotool click 0xc1";
          };
          "pulseaudio" = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% 󰥰 {format_source}";
            format-bluetooth-muted = "󰟎 {format_source}";
            format-muted = "󰝟 {format_source}";
            format-source = "{volume}% 󰍬";
            format-source-muted = "󰍭";
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
