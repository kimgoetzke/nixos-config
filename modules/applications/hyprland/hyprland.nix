{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  userSettings,
  ...
}: let
  cfg = config.hyprland;
in {
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Wayland with Hyprland";
  };

  imports = [
    (import ./waybar.nix {inherit config pkgs lib userSettings;})
    (import ./rofi.nix {inherit config pkgs lib userSettings;})
    ./mako.nix
    (import ./cliphist.nix {inherit config pkgs lib userSettings;})
    (import ./hyprlock.nix {inherit config pkgs lib userSettings;})
    ./scripts.nix
    ./kanshi.nix
  ];

  config = lib.mkIf cfg.enable {
    waybar.enable = true;
    rofi.enable = true;
    mako.enable = true;
    cliphist.enable = true;
    hyprlock.enable = true;
    kanshi.enable = false;

    home.packages = with pkgs; [
      swww # Wallpaper daemon
      brightnessctl # Tool to control brightness
      grimblast # Screenshot tool TODO: Remove once happy with grim + satty + screeny
      polkit_gnome # A dbus session bus service used to bring up authentication dialogs
      xwaylandvideobridge
      cliphist # Clipboard manager
      wl-clipboard # Wayland clipboard manager, dependency of cliphist
      gvfs # Mount, trash, and other functionalities (for Thunar)
      mako # Notification daemon
      hypridle # Idle manager
      libnotify # Notification daemon
      hyprpicker # Colour picker
      nerdfonts
      blueman # Bluetooth manager
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
        "$terminal" = "alacritty";
        exec-once = [
          "hypridle"
          "hyprlock"
          "swww-daemon"
          "swww img ${userSettings.targetDirectory}/wallpaper.png"
          "mako"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "sleep 10 && ${userSettings.targetDirectory}/reload-ui.sh"
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
          inactive_opacity = 0.85;
          rounding = 7;
          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          blur = {
            enabled = true;
            size = 5;
            passes = 1;
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
        gestures.workspace_swipe = "on";
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        windowrulev2 = [
          "float, title:^(Firefox — Sharing Indicator)$"
          "noborder, title:^(Firefox — Sharing Indicator)$"
          "rounding 0, title:^(Firefox — Sharing Indicator)$"
          "float, title:^(firefox)$, title:^(Picture-in-Picture)$"
          "pin, title:^(firefox)$, title:^(Picture-in-Picture)$"
          "float, title:^(Save File)$"
          "pin, title:^(Save File)$"
          "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"
          "tile, class:^(Aseprite)$,title:^(Aseprite)$"
          "float, class:^(.*blueman-manager.*)$,title:^(.*blueman-manager.*)$"
          "center, class:^(.*blueman-manager.*)$,title:^(.*blueman-manager.*)$"
          "float, title:^(Welcome to JetBrains Rider)$"
          "float, title:^(Welcome to WebStorm)$"
          "float, title:^(Welcome to IntelliJ.*)$"
          "float, title:^(Rusteroids)$"
          "center, title:^(Rusteroids)$"
          "float, title:^(JetBrains Toolbox)$"
          "center, title:^(JetBrains Toolbox)$"
        ];
        layerrule = [
          "blur, notifications"
          "dimaround, notifications"
          "blur, rofi"
          "dimaround, rofi"
        ];
        bind =
          [
            # General
            "$mainMod SHIFT, F1, exec, ${userSettings.targetDirectory}/main-monitor-detector.sh"
            "$mainMod SHIFT, F2, exec, wdisplays"
            "$mainMod SHIFT, E, exec, ${userSettings.targetDirectory}/power-menu.sh"
            "$mainMod SHIFT, F4, exec, ${userSettings.targetDirectory}/toggle-performance-mode.sh"
            "$mainMod SHIFT, F5, exec, ${userSettings.targetDirectory}/reload-ui.sh"
            "$mainMod SHIFT, K, exec, ${userSettings.targetDirectory}/hyprland-keybindings.sh"

            # Apps
            "$mainMod, SPACE, exec, killall rofi || rofi -show-icons -show drun"
            "$mainMod, M, exec, thunar"
            "$mainMod, F, exec, firefox"
            "$mainMod, T, exec, $terminal"
            "$mainMod, J, exec, jetbrains-toolbox"
            "$mainMod, O, exec, obsidian"
            "$mainMod, C, exec, code"
            "$mainMod, A, exec, aseprite"
            "$mainMod, X, exec, alacritty -e kalker"
            "$mainMod, K, exec, kooha" # GIF screen recorder
            "$mainMod, S, exec, hyprctl clients | awk '/class:/ {print $2}' | grep -q 'steam' && hyprctl dispatch closewindow steam || steam"
            "$mainMod SHIFT, V, exec, rofi -modi clipboard:~/.config/cliphist/cliphist-rofi-img -show clipboard -show-icons"
            "$mainMod, V, exec, cliphist list | rofi -dmenu -theme-str \"window { location: northeast; anchor: northeast; y-offset: 5; x-offset: -60; } inputbar { children: [textbox-prompt-colon, entry]; }\" | cliphist decode | wl-copy"
            "$mainMod SHIFT, C, exec, hyprpicker -f hex -a"

            # Screenshots
            "CONTROL SHIFT, P, exec, grimblast save screen" # Full screen
            "CONTROL SHIFT, bracketleft, exec, grimblast save active" # Active window
            "CONTROL SHIFT, bracketright, exec, grimblast save area" # Manually select
            "$mainMod SHIFT, P, exec, ${userSettings.targetDirectory}/screeny.sh fullscreen" # Full screen and pipe into annotation tool
            "$mainMod SHIFT, bracketleft, exec, ${userSettings.targetDirectory}/screeny.sh window" # Selected window and pipe into annotation tool
            "$mainMod SHIFT, bracketright, exec, ${userSettings.targetDirectory}/screeny.sh area" # Manually select and pipe into annotation tool

            # Volume
            ",0x1008FF11, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
            ",0x1008FF13, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
            ",0x1008FF12, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"

            # Brightness
            ",XF86MonBrightnessUp,exec,brightnessctl s +5%"
            ",XF86MonBrightnessDown,exec,brightnessctl s 5%-"

            # Lock screen
            ",switch:on:Lid Switch, exec, pidof hyprlock || hyprlock"
            "$mainMod, L, exec, hyprlock"

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
            "$mainMod SHIFT, S, movetoworkspace, special:magic"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
            "$mainMod ALT, right, resizeactive, 50 0"
            "$mainMod ALT, left, resizeactive, -50 0"
            "$mainMod ALT, up, resizeactive, 0 -50"
            "$mainMod ALT, down, resizeactive, 0 50"
            "$mainMod, code:49, workspace, 10" # $mainMod + ` = got to workspace 10
            "$mainMod SHIFT, code:49, movetoworkspacesilent, 10" # $mainMod + SHIFT + ` = move active silently to workspace 10
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
