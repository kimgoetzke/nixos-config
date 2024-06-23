{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  # Power menu ---------------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/power-menu.sh" = {
    text = ''
      #!/bin/sh
      # Inspired by https://github.com/ericmurphyxyz/dotfiles/blob/master/.local/bin/powermenu

      CHOSEN=$(printf "  Lock\n  Suspend\n  Reboot\n󰈆  Shutdown\n󰗽  Log Out" | rofi -dmenu -i -theme-str "window { location: northeast; anchor: northeast; y-offset: 5; x-offset: -10; } inputbar { children: [textbox-prompt-colon, entry]; }")

      case "$CHOSEN" in
      	"  Lock") (pidof hyprlock || hyprlock) ;;
      	"  Suspend") systemctl suspend-then-hibernate ;;
      	"  Reboot") reboot ;;
      	"󰈆  Shutdown") ${userSettings.relativeTargetDirectory}/shutdown-gracefully.sh ;;
      	"󰗽  Log Out") hyprctl dispatch exit ;;
      	*) exit 1 ;;
      esac
    '';
    executable = true;
  };

  # Shutdown gracefully ------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/shutdown-gracefully.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Thanks to https://www.reddit.com/r/hyprland/comments/12dhbuk/comment/jmjadmw/
      notify-send "󱠡  Ciao, ciao and goodbye"

      # Close all client windows (required for graceful exit since many apps aren't good SIGNAL citizens)
      HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
      hyprctl --batch "$HYPRCMDS"

      # Let's go!
      sleep 1
      shutdown now
    '';
    executable = true;
  };

  # Reload UI ----------------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/reload-ui.sh" = {
    text = ''
      #!/usr/bin/env bash
      pkill waybar
      hyprctl reload

      if [[ $USER == "${userSettings.userName}" ]]; then
          waybar -c /home/${userSettings.userName}/.config/waybar/config & -s /home/${userSettings.userName}/.config/waybar/style.css
      else
        waybar &
      fi
    '';
    executable = true;
  };
}
