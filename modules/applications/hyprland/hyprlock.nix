{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    hyprlock.enable = lib.mkEnableOption "Enable hyprlock & hypridle";
  };

  config = lib.mkIf config.hyprlock.enable {
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    services.hypridle.settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 180;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend";
        }
      ];
    };
    # TODO: Disable all other screens (also on lid close)
    home.file.".config/hypr/hyprlock.conf".text = ''
      background {
        monitor =
        path = ${userSettings.targetDirectory}/wallpaper.png
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
        text = cmd[update:1000] echo "$(date +%A) $(date +%e) $(date +%B) $(date +%Y)"
        color = rgb(${config.lib.stylix.colors.base06-rgb-r},${config.lib.stylix.colors.base06-rgb-g},${config.lib.stylix.colors.base06-rgb-b})
        font_size = 16
        font_family = DejaVu Sans
        rotate = 0
        position = 0, -20
        halign = center
        valign = top
      }

      label {
        monitor =
        text = cmd[update:1000] echo "$(date +%H:%M)"
        color = rgb(${config.lib.stylix.colors.base06-rgb-r},${config.lib.stylix.colors.base06-rgb-g},${config.lib.stylix.colors.base06-rgb-b})
        font_size = 32
        font_family = DejaVu Sans
        rotate = 0
        position = 0, -60
        halign = center
        valign = top
      }

      image {
        monitor = eDP-1
        path = ${userSettings.targetDirectory}/profile.png
        size = 250 # lesser side if not 1:1 ratio
        rounding = -1 # negative values mean circle
        border_size = 0
        border_color = rgb(${config.lib.stylix.colors.base0D-rgb-r},${config.lib.stylix.colors.base0D-rgb-g},${config.lib.stylix.colors.base0D-rgb-b})
        rotate = 0 # degrees, counter-clockwise
        position = 0, 200
        shadow_passes = 1
        shadow_size = 7
        shadow_boost = 0.5
        halign = center
        valign = center
      }

      # Alpha channel doesn't seem to respond, so it doesn't make sense to use it...
      # shape {
      #     monitor = eDP-1
      #     size = 1000, 600
      #     color = rgba(${config.lib.stylix.colors.base00-rgb-r},${config.lib.stylix.colors.base00-rgb-g},${config.lib.stylix.colors.base00-rgb-b},0.5)
      #     rounding = 20
      #     border_size = 8
      #     border_color = rgba(${config.lib.stylix.colors.base02-rgb-r},${config.lib.stylix.colors.base02-rgb-g},${config.lib.stylix.colors.base02-rgb-b},1.0)
      #     rotate = 0
      #     xray = false # if true, make a "hole" in the background (rectangle of specified size, no rotation)
      #     position = 0, 120
      #     halign = center
      #     valign = center
      # }

      label {
        monitor = eDP-1
        text = Hi $DESC
        color = rgb(${config.lib.stylix.colors.base04-rgb-r},${config.lib.stylix.colors.base04-rgb-g},${config.lib.stylix.colors.base04-rgb-b})
        font_size = 20
        font_family = DejaVu Sans
        rotate = 0
        position = 0, 40
        halign = center
        valign = center
      }

      input-field {
        monitor = eDP-1
        size = 350, 50
        outline_thickness = 0
        dots_size = 0.3 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true
        dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
        outer_color = rgb(${config.lib.stylix.colors.base0A-rgb-r},${config.lib.stylix.colors.base0A-rgb-g},${config.lib.stylix.colors.base0A-rgb-b})
        inner_color = rgb(${config.lib.stylix.colors.base00-rgb-r},${config.lib.stylix.colors.base00-rgb-g},${config.lib.stylix.colors.base00-rgb-b})
        font_color = rgb(${config.lib.stylix.colors.base06-rgb-r},${config.lib.stylix.colors.base06-rgb-g},${config.lib.stylix.colors.base06-rgb-b})
        fade_on_empty = true
        fade_timeout = 3000 # Milliseconds before fade_on_empty is triggered.
        placeholder_text = Enter your password...
        hide_input = false
        rounding = -1 # -1 means complete rounding (circle/oval)
        check_color = rgb(${config.lib.stylix.colors.base00-rgb-r},${config.lib.stylix.colors.base00-rgb-g},${config.lib.stylix.colors.base00-rgb-b})
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
        shadow_passes = 1
        shadow_size = 4
        shadow_boost = 0.5
      }
    '';
  };
}
