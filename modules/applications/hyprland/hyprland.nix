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
      xfce.thunar
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
          "swww img /home/kgoe/projects/nixos-config/assets/images/wallpaper_abstract_nord4x.png" # TODO: Copy file or somehow use relative path
          #"wl-paste --type text --watch cliphist store"
          #"wl-paste --type image --watch cliphist store"
        ];
        monitor = [
          "DP-2,preferred,0x0,1,transform,3"
          "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579,preferred,1440x500,1"
          "eDP-1,1920x1080,4000x600,1"
          ",preferred,0x0,1"
        ];
        workspace = [
          "1,monitor:DP-2"
          "2,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579,default:true"
          "3,monitor:eDP-1"
          "4,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "5,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "6,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "7,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "8,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "8,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "9,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
          "10,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
        ];
        input = {
          kb_layout = "gb";
          kb_options = "altr:end"; # TODO: Try to make this work
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
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"
          "tile,class:^(Asperite.*)$,class:^(Aseprite.*)$"
        ];
        windowrule = [
          "float,title:^(JetBrains Toolbox)$"
          "center (1),title:^(JetBrains Toolbox)$"
          "move onscreen 50% 50%,title:^(JetBrains Toolbox)$"
        ];
        layerrule = "blur, waybar";
        bind =
          [
            # General
            "$mainMod SHIFT, E, exit,"

            # Apps
            "$mainMod, SPACE, exec, killall rofi || rofi -show-icons -show drun"
            "$mainMod, M, exec, thunar"
            "$mainMod, F, exec, firefox"
            "$mainMod, T, exec, $terminal"
            "$mainMod, J, exec, jetbrains-toolbox"
            "$mainMod, O, exec, obsidian"
            "$mainMod, C, exec, code"
            "$mainMod, A, exec, aseprite"
            "CONTROL_SHIFT, V, exec, cliphist" # TODO: Make clipboard manager work
            "$mainMod, V, exec, cliphist" # TODO: Make clipboard manager work

            # Screenshots
            "CONTROL SHIFT, P, exec, grimblast save screen" # Full screen
            "CONTROL SHIFT, bracketleft, exec, grimblast save active" # Active window
            "CONTROL SHIFT, bracketright, exec, grimblast save area" # Manually select
            "$mainMod SHIFT, bracketright, exec, grimblast save area" # Manually select

            # Volume
            ",0x1008FF11,exec,wpctl set-volume @DEFAULT_SINK@ 5%-"
            ",0x1008FF13,exec,wpctl set-volume @DEFAULT_SINK@ 5%+"
            ",0x1008FF12,exec,wpctl set-mute @DEFAULT_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"

            # Brightness
            ",XF86MonBrightnessUp,exec,brightnessctl s +5%"
            ",XF86MonBrightnessDown,exec,brightnessctl s 5%-"

            # Windows & workspaces
            "$mainMod, Q, togglefloating, "
            "$mainMod, W, togglesplit,"
            "$mainMod, F12, fullscreen, 0"
            "$mainMod CONTROL SHIFT, P, pin"
            "$mainMod SHIFT, Q, killactive, "
            "$mainMod, down, movefocus, d"
            "$mainMod, up, movefocus, u"
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod SHIFT, down, movewindow,d"
            "$mainMod SHIFT, up, movewindow,u"
            "$mainMod SHIFT, left, movewindow,l"
            "$mainMod SHIFT, right, movewindow,r"
            "$mainMod CONTROL, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
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
