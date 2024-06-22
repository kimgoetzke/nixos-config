{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  # Graceful shutdown script -----------------------------------------------------------------------------------------
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

  # Reload UI helper -------------------------------------------------------------------------------------------------
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

  # Shutdown helper --------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/shutdown-helper.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Thanks to https://gitlab.com/stephan-raabe!
      if [[ "$1" == "exit" ]]; then
          echo ":: Exit"
          sleep 0.5
          killall -9 Hyprland sleep 2
      fi

      if [[ "$1" == "lock" ]]; then
          echo ":: Lock"
          sleep 0.5
          (pidof hyprlock || hyprlock)
      fi

      if [[ "$1" == "reboot" ]]; then
          echo ":: Reboot"
          sleep 0.5
          systemctl reboot
      fi

      if [[ "$1" == "shutdown" ]]; then
          echo ":: Shutdown"
          sleep 0.5
          systemctl poweroff
      fi

      if [[ "$1" == "suspend" ]]; then
          echo ":: Suspend"
          sleep 0.5
          systemctl suspend
      fi

      if [[ "$1" == "hibernate" ]]; then
          echo ":: Hibernate"
          sleep 1;
          systemctl hibernate
      fi
    '';
    executable = true;
  };
}
