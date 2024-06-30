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
      # Thank you, Eric Murphy! See: https://github.com/ericmurphyxyz/dotfiles/blob/master/.local/bin/powermenu

      CHOSEN=$(printf "  Lock\n  Suspend\n  Reboot\n󰈆  Shutdown" | rofi -dmenu -i -theme-str "window { location: northeast; anchor: northeast; y-offset: 5; x-offset: -10; } inputbar { children: [textbox-prompt-colon, entry]; }")

      case "$CHOSEN" in
      	"  Lock") (pidof hyprlock || hyprlock) ;;
      	"  Suspend") systemctl suspend-then-hibernate ;;
      	"  Reboot") reboot ;;
      	"󰈆  Shutdown") ${userSettings.targetDirectory}/shutdown-gracefully.sh ;;
      	*) exit 1 ;;
      esac
    '';
    executable = true;
  };

  # Shutdown gracefully ------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/shutdown-gracefully.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Thank you, u/timblaktu! See: https://www.reddit.com/r/hyprland/comments/12dhbuk/comment/jmjadmw/
      notify-send "Ciao, ciao 󱠡 "

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

      if [[ $USER == "${userSettings.user}" ]]; then
          waybar -c /home/${userSettings.user}/.config/waybar/config & -s /home/${userSettings.user}/.config/waybar/style.css
      else
        waybar &
      fi
    '';
    executable = true;
  };

  # Hyprland keybindings --------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/hyprland-keybindings.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Thank you, Jason Kuan! See: https://github.com/jason9075/rofi-hyprland-keybinds-cheatsheet
      HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

      # Extract the keybinding from hyprland.conf
      mapfile -t BINDINGS < <(grep '^bind=' "$HYPR_CONF" | \
          sed -e 's/  */ /g' -e 's/bind=//g' -e 's/, /,/g' -e 's/ # /,/' | \
          awk -F, -v q="'" '{cmd=""; for(i=3;i<NF;i++) cmd=cmd $(i) " ";print "<b>"$1 " + " $2 "</b>:  <i>" $NF "</i>, <span>" cmd "</span>"}')

      CHOICE=$(printf '%s\n' "''${BINDINGS[@]}" | rofi -dmenu -i -markup-rows -p "󰌌 " -theme-str "window { width: 1200px; }")

      # Extract cmd from <span>cmd</span>
      CMD=$(echo "$CHOICE" | sed -n 's/.*<span>\(.*\)<\/span>.*/\1/p')
      ARGUMENT=$(echo "$CHOICE" | sed -n 's/.*<i>\(.*\)<\/i>.*/\1/p')

      # Execute it if first word is 'exec'
      if [[ $CMD == exec* ]]; then
          eval "$CMD $ARGUMENT"
      fi
    '';
    executable = true;
  };
}
