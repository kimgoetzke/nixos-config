{
  pkgs,
  userSettings,
  ...
}: {
  # Power menu ---------------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/power-menu.sh" = {
    text = ''
      #!/bin/sh
      # Thank you, Eric Murphy! See: https://github.com/ericmurphyxyz/dotfiles/blob/master/.local/bin/powermenu

      CHOSEN=$(printf " \n󰒲 \n \n " | rofi -dmenu -i -theme-str "
      window { fullscreen: false; location: center; anchor: center; width: 1024px; border: 0px solid; y-offset: 0px; }
      mainbox { children: [listview]; orientation: vertical; spacing: 0px; }
      listview { scrollbar: false; layout: vertical; spacing: 50px; columns: 4; lines: 1; cycle: true; dynamic: true; reverse: false; fixed-height: true; fixed-columns: true; horizontal-align: 0.5; vertical-align: 0.5; }
      element { width: 110px; height: 150px; border-radius: 10px; horizontal-align: 0.5; vertical-align: 0.5; padding: 20px; }
      element-text { horizontal-align: 0.5; vertical-align: 0.5; }
      element-icon { horizontal-align: 0.5; vertical-align: 0.5; }
      * { font:  \"JetBrains Mono Regular 72\"; }
      ")

      case "$CHOSEN" in
      	" ") (pidof hyprlock || hyprlock) ;;
      	"󰒲 ") systemctl suspend-then-hibernate ;;
      	" ") reboot ;;
      	" ") ${userSettings.targetDirectory}/shutdown-gracefully.sh ;;
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

  # Rofi calculator ----------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/rofi-calculator.sh" = {
    text = ''
      #!/usr/bin/env bash

      if pgrep -x rofi > /dev/null; then
          pkill -x rofi
          exit 0
      fi

      rofi -show calc \
          -modi calc \
          -no-show-match \
          -no-sort \
          -no-persist-history \
          -calc-command "printf '%s' '{result}' | wl-copy" \
          -theme-str "entry { placeholder: 'Enter calculation...'; } textbox { padding: 40px 0px; background-color: transparent; text-color: @accent-color; } listview { scrollbar: false; } inputbar { padding: 16px; }"
    '';
    executable = true;
  };
  home.shellAliases.roficalculator = "${userSettings.targetDirectory}/rofi-calculator.sh";

  # Toggle performance mode --------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/toggle-performance-mode.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      animations_enabled=$(hyprctl -j getoption animations:enabled | ${pkgs.jq}/bin/jq -r '.bool')

      if [[ "$animations_enabled" == "true" ]]; then
        # Hyprland's Lua config parser only supports runtime changes through eval.
        hyprctl eval 'hl.config({
          animations = { enabled = false },
          decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
          },
          general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 0,
          },
        })'

        if command -v noctalia >/dev/null 2>&1; then
          noctalia msg bar-hide || true
        fi
        exit 0
      fi

      # Reloading restores the configured visual settings.
      hyprctl reload
      if command -v noctalia >/dev/null 2>&1; then
        noctalia msg bar-show || true
      fi
    '';
    executable = true;
  };
  home.shellAliases.toggleperformancemode = "${userSettings.targetDirectory}/toggle-performance-mode.sh";

  # Hyprland keybindings --------------------------------------------------------------------------------------------------
  home.file."${userSettings.relativeTargetDirectory}/hyprland-keybindings.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      notify_failure() {
        local message="$1"
        if command -v hyprctl >/dev/null 2>&1; then
          hyprctl notify 3 10000 "rgb(E0BB65)" "fontsize:16 $message" >/dev/null 2>&1 || true
        fi
        printf '%s\n' "$message" >&2
      }

      decode_mods() {
        local mask="$1"
        local parts=()
        (( mask & 64 )) && parts+=("SUPER")
        (( mask & 4 )) && parts+=("CONTROL")
        (( mask & 8 )) && parts+=("ALT")
        (( mask & 1 )) && parts+=("SHIFT")
        (( mask & 2 )) && parts+=("CAPS")
        (( mask & 16 )) && parts+=("MOD2")
        (( mask & 32 )) && parts+=("MOD3")
        (( mask & 128 )) && parts+=("MOD5")
        local joined=""
        local part
        for part in "''${parts[@]}"; do
          if [[ -z "$joined" ]]; then
            joined="$part"
          else
            joined="$joined + $part"
          fi
        done
        printf '%s' "$joined"
      }

      if ! command -v hyprctl >/dev/null 2>&1; then
        notify_failure "hyprctl is unavailable; cannot read live Hyprland binds"
        exit 1
      fi

      if ! BINDINGS_JSON=$(hyprctl binds -j 2>/dev/null); then
        notify_failure "Unable to query live Hyprland binds"
        exit 1
      fi

      DISPLAY_ROWS=()
      DISPATCHERS=()
      ARGS=()
      ACTIONS=()

      while IFS= read -r encoded; do
        bind_json=$(printf '%s' "$encoded" | base64 --decode)
        dispatcher=$(${pkgs.jq}/bin/jq -r '.dispatcher // ""' <<< "$bind_json")
        key=$(${pkgs.jq}/bin/jq -r 'if ((.key // "") != "") then .key elif ((.keycode // 0) != 0) then "code:\(.keycode)" else "" end' <<< "$bind_json")
        arg=$(${pkgs.jq}/bin/jq -r '.arg // ""' <<< "$bind_json")
        modmask=$(${pkgs.jq}/bin/jq -r '.modmask // 0' <<< "$bind_json")
        description=$(${pkgs.jq}/bin/jq -r 'if ((.has_description == true or .has_description == "true") and ((.description // "") != "")) then .description else "" end' <<< "$bind_json")

        [[ -z "$dispatcher" || -z "$key" ]] && continue

        mods=$(decode_mods "$modmask")
        if [[ -n "$mods" ]]; then
          chord="$mods + $key"
        else
          chord="$key"
        fi

        if [[ -n "$description" ]]; then
          action="$description"
        else
          action="$dispatcher $arg"
        fi

        DISPLAY_ROWS+=("$chord: $action")
        DISPATCHERS+=("$dispatcher")
        ARGS+=("$arg")
        ACTIONS+=("$action")
      done < <(printf '%s\n' "$BINDINGS_JSON" | ${pkgs.jq}/bin/jq -r '.[] | @base64')

      if [[ "''${#DISPLAY_ROWS[@]}" -eq 0 ]]; then
        notify_failure "No live Hyprland binds found"
        exit 1
      fi

      CHOICE_INDEX=$(printf '%s\n' "''${DISPLAY_ROWS[@]}" | rofi -dmenu -i -format i -p "󰌌 " -theme-str "window { width: 1200px; }")
      [[ "$CHOICE_INDEX" =~ ^[0-9]+$ ]] || exit 0

      DISPATCHER="''${DISPATCHERS[$CHOICE_INDEX]}"
      ARGUMENT="''${ARGS[$CHOICE_INDEX]}"
      ACTION="''${ACTIONS[$CHOICE_INDEX]}"

      if [[ "$ACTION" == exec\ * ]]; then
        hyprctl dispatch exec "''${ACTION#exec }"
      elif [[ "$DISPATCHER" == "exec" ]]; then
        hyprctl dispatch exec "$ARGUMENT"
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

      hyprctl notify 1 10000 "rgb(E0BB65)" "fontsize:16 Connected main monitor: $CONNECTED_MONITOR"
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
          hyprctl notify 3 10000 "rgb(E0BB65)" "fontsize:16 File [$file] does not exist"
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
          hyprctl notify 3 10000 "rgb(E0BB65)" "fontsize:16 No application selected"
          exit 1
      fi

      echo "Attempting to open [$file] with [$selected_app]"
      "$selected_app" "$file"
    '';
    executable = true;
  };
  home.shellAliases.openwithrofi = "${userSettings.targetDirectory}/open-with-rofi.sh";
}
