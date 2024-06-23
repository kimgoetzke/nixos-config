{
  pkgs,
  lib,
  config,
  userSettings,
  ...
}: {
  options = {
    waybar.enable = lib.mkEnableOption "Enable waybar";
  };

  config = lib.mkIf config.waybar.enable {
    stylix.targets.waybar.enable = false;
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
      settings = [
        {
          output = ["eDP-1" "DP-1"];
          layer = "top";
          height = 45;
          spacing = 5;
          margin-top = 15;
          margin-left = 20;
          margin-right = 20;
          margin-down = 0;
          modules-left = ["group/hardware"];
          modules-center = ["hyprland/workspaces"];
          modules-right = ["tray" "group/right"];
          "group/hardware" = {
            orientation = "horizontal";
            modules = [
              "cpu"
              "memory"
              "backlight"
              "pulseaudio"
              "bluetooth"
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
            # on-click = "killall connman-gtk || connman-gtk;sudo ydotool click 0xc1";
          };
          "cpu" = {
            interval = 10;
            format = "   {usage:d}%";
            max-length = 10;
          };
          "memory" = {
            format = "   {percentage}%";
          };
          "backlight" = {
            format = "{icon}  {percent}%";
            format-icons = ["󰃞" "󰃟" "󰖨"];
            tooltip-format = "Backlight at {percent}%";
          };
          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-alt = "{format_source}";
            # format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% 󰥰 {format_source}";
            format-bluetooth-muted = "󰟎 {format_source}";
            format-muted = "󰝟 {format_source}";
            format-source = "󰍬 {volume}%";
            format-source-muted = "󰍭";
            tooltip-format = "{desc}\n\nClick to toggle between output/input, scroll to change volume.";
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
          # TODO: Allow turning bluetooth off here, add  tooltip and better formatting
          "bluetooth" = {
            format = "";
            format-connected = " {num_connections} connected";
            format-disabled = " DISABLED";
            format-off = " OFF";
            interval = 30;
            on-click = "blueman-manager";
            format-no-controller = "";
            tooltip-format = "Currently, {num_connections} devices are connected to '{controller_alias}'.";
            tooltip-format-connected = "Controller '{controller_alias}' has the following {num_connections} devices connected:\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias} ({device_address})";
            tooltip-format-enumerate-connected-battery = "{device_alias} ({device_address}) {device_battery_percentage}% battery";
          };
          "hyprland/workspaces" = {
            persistent-workspaces = {
              "DP-2" = [1];
              "eDP-1" = [10];
              "DP-1" = [2 3 4 5 6 7 8 9];
            };
          };
          "tray" = {
            spacing = 10;
            icon-size = 24;
            show-passive-items = true;
          };
          # TODO: Try again after updates - displaying icons on startup and activate feature are currently broken
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
            on-click-right = "sleep 0.1 && ${userSettings.targetDirectory}/cliphist-helper.sh remove";
            tooltip-format = "Cliphist\n\n<small>Click to open and select to copy to clipboard, middle click to wipe entire history, and right click to open menu in order to remove a single item.</small>";
          };
          "battery" = {
            "states" = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            bat = "BAT0";
            format = "{icon}   {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-icons = ["" "" "" "" ""];
          };
          "clock" = {
            format = "<big>      <b>{:%H:%M</b></big>\n<small>󰃮  %d %h %Y</small>}";
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
            on-click = "sleep 0.2 && ${userSettings.targetDirectory}/power-menu.sh";
            tooltip-format = "Power menu\n\n<small>Click to open menu.</small>";
          };
        }
        {
          output = ["DP-2"];
          layer = "top";
          height = 45;
          spacing = 5;
          margin-top = 15;
          margin-left = 20;
          margin-right = 20;
          margin-down = 0;
          modules-center = ["hyprland/workspaces"];
          "hyprland/workspaces" = {
            persistent-workspaces = {
              "DP-2" = [1];
            };
          };
        }
      ];
    };
  };
}
