{
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    hypridle.enable = lib.mkEnableOption "Enable hypridle, Hyprland's idle management daemon";
  };

  config = lib.mkIf config.hypridle.enable {
    services.hypridle.enable = true;
    services.hypridle.settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd =
          if userSettings.hyprland.bar == "quickshell"
          then "noctalia-shell ipc call lockScreen lock"
          else "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl monitors -j | jq -r '.[].name' | xargs -I{} hyprctl dispatch dpms on {}";
      };
      listener = [
        {
          timeout = 180;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl monitors -j | jq -r '.[].name' | xargs -I{} hyprctl dispatch dpms off {}";
          on-resume = "hyprctl monitors -j | jq -r '.[].name' | xargs -I{} hyprctl dispatch dpms on {}";
        }
      ];
    };
  };
}
