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
      mako
      hypridle
      libnotify
      gvfs
      hyprpicker
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

    # Hyprland ---------------------------------------------------------------------------------------------------------
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      settings = {
        "$scripts" = "${./../../../assets/configs/hyprland/scripts}";
        "$mainMod" = "SUPER";
        "$terminal" = "alacritty";
        exec-once = [
          "hyprlock"
          "swww-daemon"
          "swww img /home/kgoe/projects/nixos-config/assets/images/wallpaper_abstract_nord4x.png" # TODO: Copy file or somehow use relative path
          "hypridle"
          "mako"
          "sleep 1"
          "[workspace 2] jetbrains-toolbox"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
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
          "forceinput,title:^(JetBrains Toolbox)$"
          "nofocus,title:^(JetBrains Toolbox)$"
          "float,title:^(JetBrains Toolbox)$"
          #"move onscreen 50% 50%,title:^(JetBrains Toolbox)$"
          "center,jetbrains-toolbox"
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
            "$mainMod SHIFT, V, exec, rofi -modi clipboard:~/.config/cliphist/cliphist-rofi-img -show clipboard -show-icons" # TODO: Fix file path
            "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
            "$mainMod SHIFT, L, exec, cliphist wipe"
            "$mainMod SHIFT, C, exec, hyprpicker -f hex -a"

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

            # Lock screen
            ",switch:on:Lid Switch, exec, hyprlock"
            "$mainMod, L, exec, hyprlock"

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
            "$mainMod ALT, right, resizeactive, 30 0"
            "$mainMod ALT, left, resizeactive, -30 0"
            "$mainMod ALT, up, resizeactive, 0 -30"
            "$mainMod ALT, down, resizeactive, 0 30"
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

    # Lock screen ------------------------------------------------------------------------------------------------------
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    services.hypridle.settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 30;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
      ];
    };
    # TODO: Use relative path for wallpaper below or copy it to the right place beforehand
    home.file.".config/hypr/hyprlock.conf".text = ''
      background {
        monitor =
        path = screenshot
        blur_passes = 4
        blur_size = 5
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
      }

      label {
        monitor =
        text = cmd[update:1000] echo "$(date)"
        color = rgb(${config.lib.stylix.colors.base06-rgb-r},${config.lib.stylix.colors.base06-rgb-g},${config.lib.stylix.colors.base06-rgb-b})
        font_size = 8
        font_family = DejaVu Sans
        rotate = 0
        position = 0, -20
        halign = center
        valign = top
      }

      image {
        monitor = eDP-1
        path = /home/kgoe/projects/nixos-config/assets/images/randy.png
        size = 250 # lesser side if not 1:1 ratio
        rounding = -1 # negative values mean circle
        border_size = 0
        rotate = 0 # degrees, counter-clockwise
        position = 0, 200
        halign = center
        valign = center
      }

      input-field {
        monitor = eDP-1
        size = 500, 50
        outline_thickness = 3
        dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true
        dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
        outer_color = rgb(${config.lib.stylix.colors.base0A-rgb-r},${config.lib.stylix.colors.base0A-rgb-g},${config.lib.stylix.colors.base0A-rgb-b})
        inner_color = rgb(${config.lib.stylix.colors.base00-rgb-r},${config.lib.stylix.colors.base00-rgb-g},${config.lib.stylix.colors.base00-rgb-b})
        font_color = rgb(${config.lib.stylix.colors.base0A-rgb-r},${config.lib.stylix.colors.base0A-rgb-g},${config.lib.stylix.colors.base0A-rgb-b})
        fade_on_empty = true
        fade_timeout = 3000 # Milliseconds before fade_on_empty is triggered.
        placeholder_text = Enter your password...
        hide_input = false
        rounding = -1 # -1 means complete rounding (circle/oval)
        check_color = rgb(${config.lib.stylix.colors.base0A-rgb-r},${config.lib.stylix.colors.base0A-rgb-g},${config.lib.stylix.colors.base0A-rgb-b})
        fail_color = rgb(${config.lib.stylix.colors.base08-rgb-r},${config.lib.stylix.colors.base08-rgb-g},${config.lib.stylix.colors.base08-rgb-b})
        fail_text = $FAIL (attempt $ATTEMPTS)
        fail_transition = 1000 # transition time in ms between normal outer_color and fail_color
        capslock_color = rgb(${config.lib.stylix.colors.base08-rgb-r},${config.lib.stylix.colors.base08-rgb-g},${config.lib.stylix.colors.base08-rgb-b})
        numlock_color = -1
        bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false # change color if numlock is off
        swap_font_color = false # see below
        position = 0, -40
        halign = center
        valign = center
      }

      label {
        monitor = eDP-1
        text = Hi $DESC!
        color = rgb(${config.lib.stylix.colors.base04-rgb-r},${config.lib.stylix.colors.base04-rgb-g},${config.lib.stylix.colors.base04-rgb-b})
        font_size = 20
        font_family = DejaVu Sans
        rotate = 0
        position = 0, 40
        halign = center
        valign = center
      }
    '';

    # Cliphist ---------------------------------------------------------------------------------------------------------
    services.cliphist.enable = true;
    services.cliphist.extraOptions = [
      "-max-dedupe-search"
      "10"
      "-max-items"
      "100"
    ];
    home.file.".config/cliphist/cliphist-rofi-img" = { # Required to work with rofi and images
      text = ''
        #!/usr/bin/env bash

        tmp_dir="/tmp/cliphist"
        rm -rf "$tmp_dir"

        if [[ -n "$1" ]]; then
            cliphist decode <<<"$1" | wl-copy
            exit
        fi

        mkdir -p "
        }$tmp_dir"

        read -r -d '''' prog <<EOF
        /^[0-9]+\s<meta http-equiv=/ { next }
        match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
            system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
            print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
            next
        }
        1
        EOF
        cliphist list | gawk "$prog"
      '';
      executable = true;
    };
  };
}
