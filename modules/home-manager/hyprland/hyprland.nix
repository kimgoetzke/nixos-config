{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}: let
  cfg = config.hyprland;
in {
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Wayland with Hyprland";
  };

  imports = [
    ./waybar.nix
    ./hyprpanel.nix
    ./quickshell.nix
    ./rofi.nix
    ./mako.nix
    ./cliphist.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./scripts.nix
    ./kanshi.nix
  ];

  config = lib.mkIf cfg.enable {
    rofi.enable = true; # TODO: Consider if I can make Quickshell work without Rofi
    cliphist.enable = true;
    hypridle.enable = true;
    hyprlock.enable = userSettings.hyprland.bar != "quickshell";
    kanshi.enable = false;
    hyprland-waybar.enable = userSettings.hyprland.bar == "waybar";
    hyprland-hyprpanel.enable = userSettings.hyprland.bar == "hyprpanel";
    hyprland-quickshell.enable = userSettings.hyprland.bar == "quickshell";
    hyprland-hyprpaper.enable = false;
    mako.enable = config.hyprland-waybar.enable;

    home.packages = with pkgs;
      [
        polkit_gnome # A dbus session bus service used to bring up authentication dialogs
        cliphist # Clipboard manager
        wl-clipboard # Wayland clipboard manager, dependency of cliphist
        gvfs # Mount, trash, and other functionalities (for Thunar/Nautilus)
        hypridle # Idle manager
        hyprpicker # Colour picker
      ]
      ++ lib.optionals (userSettings.hyprland.bar != "quickshell") [
        swww # Wallpaper daemon
      ]
      ++ lib.optionals config.hyprland-waybar.enable [
        brightnessctl # Tool to control brightness
        libnotify # Notification daemon
        blueman # Bluetooth manager
        mako # Notification daemon
      ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "${userSettings.emulator}";
        exec-once =
          [
            "hypridle"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          ]
          ++ lib.optionals (userSettings.hyprland.bar != "quickshell") [
            "hyprlock"
            "swww-daemon"
            "swww img ${userSettings.targetDirectory}/wallpaper.png"
          ]
          ++ lib.optionals config.hyprland-waybar.enable [
            "mako" # Conflicts with hyprpanel which comes with a notification daemon
            "sleep 10 && ${userSettings.targetDirectory}/reload-ui.sh"
          ]
          ++ lib.optionals config.hyprland-hyprpanel.enable [
            "hyprpanel"
          ]
          ++ lib.optionals config.hyprland-quickshell.enable [
            "noctalia-shell"
          ];
        monitor = [
          "DP-2,preferred,0x0,1,transform,3"
          "DP-3,preferred,0x0,1,transform,3"
          "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579,preferred,1440x500,1"
          "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104,preferred,3700x-840,1"
          "eDP-1,1920x1080,4000x600,1"
          #",preferred,0x0,1" # Currently disabled as it overlaps in some setups with existing monitors, even if not present
        ];
        workspace = [
          "1,monitor:${
            if userSettings.hyprland.hasLeftMonitor
            then userSettings.hyprland.leftMonitor
            else userSettings.hyprland.externalMonitor
          },default:true"
          "2,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579,default:true"
          "2,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104,default:true"
          "3,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "3,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
          "4,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "4,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
          "5,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "5,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
          "6,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "6,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
          "7,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "7,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
          "8,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "8,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
          "9,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "9,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
          "10,monitor:eDP-1"
        ];
        input = {
          kb_layout = "gb";
          touchpad = {
            natural_scroll = "yes";
            disable_while_typing = "no";
          };
          sensitivity = 0.1;
          scroll_method = "on_button_down";
          scroll_button = "274";
        };
        general = {
          gaps_in = 5;
          gaps_out = 15;
          border_size = 3;
          layout = "dwindle";
          allow_tearing = false;
        };
        decoration = {
          inactive_opacity = 1.0;
          rounding = 7;
          blur = {
            enabled = true;
            size = 12;
            passes = 2;
          };
          shadow = {
            enabled = false;
            range = 8;
            render_power = 3;
          };
        };
        animations = {
          enabled = 1;
          bezier = "easeOutQuart, 0.25, 1, 0.25, 1";
          animation = [
            "windows, 1, 5, easeOutQuart"
            "windowsOut, 1, 5, default, popin 60%"
            "fade, 1, 5, easeOutQuart"
            "workspaces, 1, 5, easeOutQuart"
          ];
        };
        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };
        master.new_status = "master";
        gesture = [
          "3, horizontal, workspace"
          "3, down, mod: ALT, close"
          "3, up, mod: SUPER, scale: 1.5, fullscreen"
        ];
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        windowrule = [
          "tile on, match:initial_class Aseprite"
          "float on, match:title ^(Firefox — Sharing Indicator)$"
          "border_size 0, match:title ^(Firefox — Sharing Indicator)$"
          "rounding 0, match:title ^(Firefox — Sharing Indicator)$"
          "float on, match:title ^(Picture-in-Picture)$"
          "pin on, match:title ^(Picture-in-Picture)$"
          "float on, match:title ^(Save File)$"
          "pin on, match:title ^(Save File)$"
          "float on, match:title ^(Select what to share.*)$"
          "float on, match:title ^(.*blueman-manager.*)$"
          "float on, match:class ^(.*blueman-manager.*)$"
          "center on, match:title ^(.*blueman-manager.*)$"
          "center on, match:class ^(.*blueman-manager.*)$"
          "float on, match:title ^(Welcome to JetBrains Rider)$"
          "float on, match:title ^(Welcome to WebStorm)$"
          "float on, match:title ^(Welcome to IntelliJ.*)$"
          "float on, match:title ^(Welcome to RustRover)$"
          # Rules that are not working
          "float on, match:class jetbrains-toolbox"
          "float on, match:initial_title Toolbox"
          "center on, match:class jetbrains-toolbox"
          "center on, match:initial_title Toolbox"
          "move (cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5)), match:class jetbrains-toolbox"
          # The below is a fix for the flickering in JetBrains applications, see:
          # https://github.com/hyprwm/Hyprland/issues/9355
          # https://github.com/hyprwm/Hyprland/discussions/9866
          "no_initial_focus on, match:class jetbrains-toolbox, match:initial_title win(.*)"
          "no_initial_focus on, match:class jetbrains-idea, match:initial_title win(.*)"
          "no_initial_focus on, match:class jetbrains-rustrover, match:initial_title win(.*)"
          "no_initial_focus on, match:class ^(jetbrains-)(.*) match:initial_title ^$"
          "no_focus on, match:class ^(jetbrains-)(.*) match:title ^$"
          # My apps
          "float on, match:title ^(mooplas)(.*)$"
          "center on, match:title ^(mooplas)(.*)$"
          "float on, match:title ^(Rusteroids)$"
          "center on, match:title ^(Rusteroids)$"
          # Other rules
          "idle_inhibit fullscreen, match:class .*" # Prevent idle when fullscreen
          "idle_inhibit focus, match:class .*" # Prevent idle when a window is focused
        ];
        layerrule = [
          "blur on, match:namespace rofi"
          "dim_around on, match:namespace rofi"
          "blur on, match:namespace = noctalia-background-.*$"
          "blur_popups on, match:namespace = noctalia-background-.*$"
          "ignore_alpha on, match:namespace = noctalia-background-.*$"
        ];
        bind =
          [
            # General
            "$mainMod SHIFT, F1, exec, ${userSettings.targetDirectory}/hyprland-keybindings.sh"
            "$mainMod SHIFT, F2, exec, ${userSettings.targetDirectory}/main-monitor-detector.sh"
            "$mainMod SHIFT, F3, exec, wdisplays"
            "$mainMod SHIFT, F4, exec, ${userSettings.targetDirectory}/toggle-performance-mode.sh"
            "$mainMod SHIFT, F5, exec, ${userSettings.targetDirectory}/reload-ui.sh"

            # Apps
            "$mainMod, N, exec, $terminal -e nmtui"
            "$mainMod, M, exec, nautilus"
            "$mainMod, Y, exec, $terminal -e yazi"
            "$mainMod, F, exec, firefox"
            "$mainMod, T, exec, $terminal"
            "$mainMod, J, exec, jetbrains-toolbox"
            "$mainMod, O, exec, obsidian"
            "$mainMod, B, exec, obs"
            "$mainMod, C, exec, code"
            "$mainMod, A, exec, aseprite"
            "$mainMod SHIFT, K, exec, $terminal -e kalker"
            "$mainMod, K, exec, pkill -x rofi || rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history -theme-str \"entry { placeholder: 'Enter calculation...'; } textbox { padding: 40px 0px; background-color: transparent; text-color: @accent-color; } listview { scrollbar: false; } inputbar { padding: 16px; }\""
            "$mainMod, X, exec, kooha" # GIF screen recorder
            "$mainMod, S, exec, hyprctl clients | awk '/class:/ {print $2}' | grep -q 'steam' && hyprctl dispatch closewindow steam || steam"
            "$mainMod SHIFT, C, exec, hyprpicker -f hex -a"

            # Screenshots
            "$mainMod SHIFT, P, exec, ${userSettings.targetDirectory}/screeny.sh fullscreen" # Full screen and pipe into annotation tool
            "$mainMod SHIFT, bracketleft, exec, ${userSettings.targetDirectory}/screeny.sh window" # Selected window and pipe into annotation tool
            "$mainMod SHIFT, bracketright, exec, ${userSettings.targetDirectory}/screeny.sh area" # Manually select and pipe into annotation tool

            # Screen recording
            "$mainMod SHIFT, R, exec, ${userSettings.targetDirectory}/screeny.sh record-area" # Manually select area and record

            # Volume
            ",0x1008FF11, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
            ",0x1008FF13, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
            ",0x1008FF12, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"

            # Brightness
            ",XF86MonBrightnessUp,exec,brightnessctl s +5%"
            ",XF86MonBrightnessDown,exec,brightnessctl s 5%-"

            # Windows & workspaces
            "$mainMod, Q, togglefloating, "
            "$mainMod, W, togglesplit,"
            "$mainMod, F11, fullscreen, 0"
            "$mainMod CONTROL SHIFT, P, pin"
            "$mainMod SHIFT, Q, killactive, "
            "ALT, F4, killactive, "
            "$mainMod, down, movefocus, d"
            "$mainMod, up, movefocus, u"
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod SHIFT, down, movewindow, d"
            "$mainMod SHIFT, up, movewindow, u"
            "$mainMod SHIFT, left, movewindow, l"
            "$mainMod SHIFT, right, movewindow, r"
            "$mainMod CONTROL, S, togglespecialworkspace, magic"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
            "$mainMod ALT, right, resizeactive, 50 0"
            "$mainMod ALT, left, resizeactive, -50 0"
            "$mainMod ALT, up, resizeactive, 0 -50"
            "$mainMod ALT, down, resizeactive, 0 50"
            "$mainMod, code:49, workspace, 10" # $mainMod + ` = got to workspace 10
            "$mainMod SHIFT, code:49, movetoworkspacesilent, 10" # $mainMod + SHIFT + ` = move active silently to workspace 10
          ]
          ++ lib.optionals (userSettings.hyprland.bar == "quickshell") [
            # Launchers & menus
            "$mainMod, SPACE, exec, noctalia-shell ipc call launcher toggle"
            "$mainMod, period, exec, noctalia-shell ipc call launcher emoji"
            "$mainMod SHIFT, S, exec, noctalia-shell ipc call settings toggle"
            "$mainMod, V, exec, noctalia-shell ipc call launcher clipboard"

            # Volume and brightness
            ",XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
            ",XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
            ",XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
            ",XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
            ",XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"

            # Lock & power
            "$mainMod, L, exec, noctalia-shell ipc call lockScreen lock"
            "$mainMod SHIFT, E, exec, noctalia-shell ipc call sessionMenu toggle"
          ]
          ++ lib.optionals (userSettings.hyprland.bar != "quickshell") [
            # Launchers & menus
            "$mainMod, SPACE, exec, pkill -x rofi || rofi -show-icons -show drun"
            "$mainMod, period, exec, pkill -x rofi || rofi -show-icons -show emoji"

            # Lock & power
            "$mainMod SHIFT, E, exec, pkill -x rofi || ${userSettings.targetDirectory}/power-menu.sh"
            "$mainMod, L, exec, hyprlock"
            ",switch:on:Lid Switch, exec, pidof hyprlock || hyprlock"

            # Clipboard
            "$mainMod SHIFT, V, exec, ${userSettings.targetDirectory}/cliphist-helper.sh wipe"
            "$mainMod, V, exec, ${userSettings.targetDirectory}/cliphist-helper.sh open"
          ]
          ++ (
            # Select and move workspaces 1 to 10
            builtins.concatLists (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    builtins.toString (x + 1 - (c * 10));
                in [
                  "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mainMod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                ]
              )
              10)
          );
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
