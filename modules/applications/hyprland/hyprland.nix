{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  userSettings,
  ...
}: let
  cfg = config.de-hyprland;
in {
  options.de-hyprland = {
    enable = lib.mkEnableOption "Enable Wayland with Hyprland as desktop environment";
  };

  imports = [
    ./waybar.nix
    ./rofi.nix
    ./mako.nix
  ];

  config = lib.mkIf cfg.enable {
    waybar.enable = true;
    rofi.enable = true;
    mako.enable = true;

    home.packages = with pkgs; [
      swww
      brightnessctl
      grimblast
      cliphist
      polkit_gnome
      xwaylandvideobridge
      wl-clipboard
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
        "$scripts" = "${./../../../assets/configs/hyprland/scripts}";
        "$mainMod" = "SUPER";
        "$terminal" = "alacritty";

        exec-once = [
          "swww-daemon"
          "swww img /home/kgoe/projects/nixos-config/assets/images/wallpaper_abstract_nord4x.png"
        ];

        monitor = ",preferred,auto,1.333333,mirror,eDP-1";
        #        monitor = [ ",preferred,auto,1.25,mirror,eDP-1"  "eDP-1,1920x1080@60.00H,auto,1.25,mirror,eDP-1" ];

        input = {
          kb_layout = "gb";
          touchpad = {
            natural_scroll = "yes";
            disable_while_typing = "no";
          };
          sensitivity = 0.1;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 3;
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 7;
          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        animations = {
          enabled = 1;
          bezier = "overshot,0.13,0.99,0.29,1.1,";
          animation = [
            "fade,1,4,default"
            "workspaces,1,4,default,fade"
            "windows,1,4,overshot,popin 95%"
          ];
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };

        master.new_is_master = true;
        gestures.workspace_swipe = "on";
        misc.force_default_wallpaper = 1;

        # TODO: Window rule for Jetbrains Toolbox to swpan in the center
        windowrulev2 = [
          "float, title:^(Firefox — Sharing Indicator)$"
          "noborder, title:^(Firefox — Sharing Indicator)$"
          "rounding 0, title:^(Firefox — Sharing Indicator)$"
          "float, title:^(firefox)$, title:^(Picture-in-Picture)$"
          "pin, title:^(firefox)$, title:^(Picture-in-Picture)$"
          "float, title:^(Save File)$"
          "pin, title:^(Save File)$"
          "float, title:^(Torrent Options)$"
          "pin, title:^(Torrent Options)$"
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"
          "windowdance,class:^(kompas.exe)$,title:^(RoamingWindow)$"
          "stayfocused,class:^(kompas.exe)$,title:^(RoamingWindow)$"
        ];

        windowrule = [
          "windowdance,title:^(Rhythm Doctor)$"
          "forceinput,title:^(Rhythm Doctor)$"
        ];

        layerrule = "blur, waybar";

        bind =
          [
            "$mainMod, V, togglefloating, "
            "$mainMod, P, pseudo,"
            "$mainMod, I, togglesplit,"
            "$mainMod SHIFT, F, fullscreen, 0"
            #"$mainMod SHIF, M, fullscreen, 1"
            "$mainMod SHIFT, Q, killactive, "
            "$mainMod SHIFT, E, exit,"

            # Apps
            "$mainMod, D, exec, killall rofi || rofi -show-icons -show drun"
            "$mainMod, SPACE, exec, killall rofi || rofi -show-icons -show drun"
            # "$mainMod, Q, exec, "
            "$mainMod, F, exec, firefox"
            "$mainMod, T, exec, $terminal"
            "$mainMod, J, exec, jetbrains-toolbox"
            "$mainMod, O, exec, obsidian"
            "$mainMod, C, exec, code"
            "$mainMod, A, exec, aseprite"
            "$mainMod SHIFT, Esc, exec, swww img /home/kgoe/projects/nixos-config/assets/images/wallpaper_abstract_nord4x.png"

            # Screenshooting
            ", Print, exec, grimblast save screen"
            "ALT, P, exec, grimblast save active"
            "SHIFT, P, exec, grimblast save area"
            "CONTROL, P, exec, grimblast copy screen"
            "ALT_CONTROL, P, exec, grimblast copy active"
            "CONTROL_SHIFT, P, exec, grimblast copy area"

            # Volume
            ",0x1008FF11,exec,wpctl set-volume @DEFAULT_SINK@ 5%-"
            ",0x1008FF13,exec,wpctl set-volume @DEFAULT_SINK@ 5%+"
            ",0x1008FF12,exec,wpctl set-mute @DEFAULT_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"

            # Brightness
            ",XF86MonBrightnessUp,exec,brightnessctl s +5%"
            ",XF86MonBrightnessDown,exec,brightnessctl s 5%-"

            # Windows
            "$mainMod, down, movefocus, d"
            "$mainMod, up, movefocus, u"
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod SHIFT, down, movewindow,d"
            "$mainMod SHIFT, up, movewindow,u"
            "$mainMod SHIFT, left, movewindow,l"
            "$mainMod SHIFT, right, movewindow,r"
            #"$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
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
