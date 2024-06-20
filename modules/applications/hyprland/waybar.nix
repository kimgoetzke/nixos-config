{
  pkgs,
  lib,
  config,
  userSettings,
  ...
}: {
  options = {
    waybar.enable = lib.mkEnableOption "Enable Waybar";
  };

  config = lib.mkIf config.waybar.enable {
    # TODO: Show time/date and battery/percentage in two rows each
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
          output = ["eDP-1" "DP-1"];
          layer = "top";
          height = 30;
          spacing = 5;
          margin-top = 15;
          margin-left = 20;
          margin-right = 20;
          margin-down = 0;
          modules-left = ["group/hardware"];
          modules-center = ["hyprland/workspaces" ];
          modules-right = ["tray" "wlr/taskbar" "group/right"];
          "group/hardware" = {
            orientation = "horizontal";
            modules = [
              "cpu"
              "memory"
              "backlight"
              "pulseaudio"
            ];
          };
          "network" = {
            # Currently not show
            interface = "wlp2*";
            format-wifi = "󰤨  {essid} ({signalStrength}%)";
            format-ethernet = "{ipaddr}/{cidr} 󰈀";
            tooltip-format = "{ifname} via {gwaddr} 󰩟";
            format-linked = "{ifname} (No IP) 󰩟";
            format-disconnected = "󰤫";
            on-click = "killall connman-gtk || connman-gtk;sudo ydotool click 0xc1";
          };
          "cpu" = {
            interval = 10;
            format = "   {}%";
            max-length = 10;
          };
          "memory" = {
            format = "   {percentage}%";
          };
          "backlight" = {
            format = "{icon}  {percent}%";
            format-icons = ["󰖨"];
            tooltip-format = "Backlight at {percent}%";
          };
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% 󰥰 {format_source}";
            format-bluetooth-muted = "󰟎 {format_source}";
            format-muted = "󰝟 {format_source}";
            format-source = "󰍬 {volume}%";
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
          "hyprland/workspaces" = {
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
            };
          };
          "tray" = {
            spacing = 10;
          };
          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 14;
            tooltip-format = "{name}";
            on-click = "activate";
            on-click-middle = "close";
          };
          "group/right" = {
            orientation = "horizontal";
            modules = [
              "custom/cliphist"
              "battery"
              "clock"
              "custom/exit"
            ];
          };
          "custom/cliphist" = {
            format = "";
            on-click = "sleep 0.1 && ${userSettings.targetDirectory}/cliphist-helper.sh open";
            on-click-middle = "sleep 0.1 && ${userSettings.targetDirectory}/cliphist-helper.sh wipe";
            tooltip-format = "Clipboard Manager";
          };
          "battery" = {
            "states" = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon}   {capacity}%";
            format-charging = "󰂄  {capacity}%";
            format-plugged = "  {capacity}%";
            format-icons = ["" "" "" "" ""];
          };
          "clock" = {
            format = "{:%H:%M}";
            format-alt = "󰃮  {:%d %h %Y}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              "format" = {
                months = "<span color='${config.lib.stylix.colors.withHashtag.base0D}'><b>{}</b></span>";
                days = "<span color='${config.lib.stylix.colors.withHashtag.base06}'><b>{}</b></span>";
                weeks = "<span color='${config.lib.stylix.colors.withHashtag.base07}'><b>W{}</b></span>";
                weekdays = "<span color='${config.lib.stylix.colors.withHashtag.base0F}'><b>{}</b></span>";
                today = "<span color='${config.lib.stylix.colors.withHashtag.base08}'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
          "custom/exit" = {
            format = "";
            on-click = "notify-send \"󱠡  Ciao, ciao and goodbye\" ; sleep 1 ; ${userSettings.relativeTargetDirectory}/shutdown-gracefully.sh";
            tooltip-format = "Shutdown of the system";
          };
        };
      };
    };
  };
}
