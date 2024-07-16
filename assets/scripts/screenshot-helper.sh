#!/usr/bin/env bash
# Note: Only works in Wayland compositors - used by hyprland/scripts.nix.

screenshot() {
  case "$1" in
  "fullscreen" | "fs")
    grim -g "$(slurp -o -r -c '#b48ead00')" - | satty --filename - --init-tool crop --output-filename "$HOME/Pictures/$(date '+%Y%m%d-%H:%M:%S').png" --early-exit
    ;;
  "window" | "w")
    grim -g "$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)""| jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"'| slurp -d -c '#b48eadff')" - | satty --filename - --init-tool crop --output-filename "$HOME/Pictures/$(date '+%Y%m%d-%H:%M:%S').png" --early-exit
    ;;
  "area" | "manual" | "a" | "m")
    grim -g "$(slurp -d -c '#b48eadff')" - | satty --filename - --init-tool crop --output-filename "$HOME/Pictures/$(date '+%Y%m%d-%H:%M:%S').png" --early-exit
    ;;
  *)
    echo "Error: Command '$1' not recognised."
    notify-send "  Error: Command '$1' not recognised."
    ;;
  esac
}

screenshot "$1"
