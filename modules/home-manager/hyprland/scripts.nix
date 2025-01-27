{userSettings, ...}: {
  # Power menu ---------------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/power-menu.sh" = {
    text = ''
      #!/bin/sh
      # Thank you, Eric Murphy! See: https://github.com/ericmurphyxyz/dotfiles/blob/master/.local/bin/powermenu

      CHOSEN=$(printf "  Lock\n  Suspend\n  Reboot\n󰈆  Shutdown" | rofi -dmenu -i -theme-str "window { location: center; anchor: center; width: 300px; } mainbox { children: [listview]; } listview { scrollbar: false; }")

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
  home.shellAliases.powermenu = "${userSettings.targetDirectory}/power-menu.sh";

  # Shutdown gracefully ------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/shutdown-gracefully.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Thank you, u/timblaktu! See: https://www.reddit.com/r/hyprland/comments/12dhbuk/comment/jmjadmw/

      # Close all client windows (required for graceful exit since many apps aren't good SIGNAL citizens)
      HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
      hyprctl --batch "$HYPRCMDS"

      # Let's go!
      sleep 1
      shutdown now
    '';
    executable = true;
  };
  home.shellAliases.shutdowngracefully = "${userSettings.targetDirectory}/shutdown-gracefully.sh";

  # Reload UI ----------------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/reload-ui.sh" = {
    text = ''
      #!/usr/bin/env bash
      hyprctl reload
      if pgrep waybar > /dev/null; then
        pkill waybar
        waybar -c /home/${userSettings.user}/.config/waybar/config & -s /home/${userSettings.user}/.config/waybar/style.css
      fi

      if pgrep hyprpanel > /dev/null; then
        pkill hyprpanel
        hyprpanel &
      fi
    '';
    executable = true;
  };
  home.shellAliases.reloadui = "${userSettings.targetDirectory}/reload-ui.sh";

  # Toggle performance mmode -------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/toggle-performance-mode.sh" = {
    text = ''
      #!/usr/bin/env bash
      HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
      if [ "$HYPRGAMEMODE" = 1 ] ; then
          pkill waybar
          hyprctl --batch "\
              keyword animations:enabled 0;\
              keyword decoration:shadow:enabled 0;\
              keyword decoration:blur:enabled 0;\
              keyword general:gaps_in 0;\
              keyword general:gaps_out 0;\
              keyword general:border_size 1;\
              keyword decoration:rounding 0"
          exit
      fi
      hyprctl reload
      waybar -c /home/${userSettings.user}/.config/waybar/config & -s /home/${userSettings.user}/.config/waybar/style.css
    '';
    executable = true;
  };
  home.shellAliases.toggleperformancemode = "${userSettings.targetDirectory}/toggle-performance-mode.sh";

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
  home.shellAliases.hyprlandkeybindings = "${userSettings.targetDirectory}/hyprland-keybindings.sh";

  # Main monitor detector ----------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/main-monitor-detector.sh" = {
    text = ''
      #!/usr/bin/env bash
      INPUT_INFO=$(hyprctl monitors all)
      MONITOR_1="GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579"
      MONITOR_2="GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104"
      CONNECTED_MONITOR_INFO=$(echo "$INPUT_INFO" | grep -e "$MONITOR_1" -e "$MONITOR_2" -m 1)

      if [ -z "$CONNECTED_MONITOR_INFO" ]; then
          CONNECTED_MONITOR="eDP-1"
          CONNECTED_PORT="eDP-1"
      else
          CONNECTED_MONITOR=$(echo "$CONNECTED_MONITOR_INFO" | grep -oP '(?<=description: ).*')
          #CONNECTED_PORT=$(echo "$INPUT_INFO" | grep -oP '(?<=Monitor ).*(?= \()')
      fi

      hyprctl notify 1 10000 "rgb(ebcb8b)" "fontsize:16 Connected main monitor: $CONNECTED_MONITOR"
      #notify-send "Connected port: $CONNECTED_PORT"
    '';
    executable = true;
  };
  home.shellAliases.mainmonitordetector = "${userSettings.targetDirectory}/main-monitor-detector.sh";

  # Screeny ------------------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/screeny.sh" = {
    source = ./../../../assets/scripts/screeny.sh;
  };
  home.shellAliases.screeny = "${userSettings.targetDirectory}/screeny.sh";

  # Open with Rofi -----------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/open-with-rofi.sh" = {
    text = ''
      #!/usr/bin/env bash

      file="$1"
      if [ ! -f "$file" ]; then
          echo "File does not exist: $file"
          hyprctl notify 3 10000 "rgb(ebcb8b)" "fontsize:16 File [$file] does not exist"
          exit 1
      fi

      search_dirs="$HOME/.local/share/applications:$(echo "$XDG_DATA_DIRS")"
      applications=$(echo "$search_dirs" | tr ':' '\n' | while read -r dir; do
          find "$dir/applications" -name '*.desktop' 2>/dev/null
      done | xargs grep -h "^Exec=" | \
          sed -E 's/^Exec=//' | \
          sed -E 's/[ ]*[%].*//' | \
          sed -E 's/[ ]+-.*//' | \
          awk '!seen[$0]++' | \
          grep -E '^[^/]' | \
          grep -Ev '^(xdg-open|Xwayland|rofi|nixos-help|umpv|rofi-theme-selector)$' | \
          grep -Ev 'http[s]?://|^/nix/store|computer://|trash://|file://' | \
          sort)

      selected_app=$(echo "$applications" | rofi -dmenu -i -p "Open with")
      if [ -z "$selected_app" ]; then
          echo "No application selected"
          hyprctl notify 3 10000 "rgb(ebcb8b)" "fontsize:16 No application selected"
          exit 1
      fi

      echo "Attempting to open [$file] with [$selected_app]"
      "$selected_app" "$file"
    '';
    executable = true;
  };
  home.shellAliases.openwithrofi = "${userSettings.targetDirectory}/open-with-rofi.sh";
}
