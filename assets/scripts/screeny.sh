#!/usr/bin/env bash
# Note: Only works in Wayland compositors - used by hyprland/scripts.nix.
# Dependencies: grim, slurp, satty, wl-copy, hyprctl, jq, wf-recorder, ffmpeg.

screeny() {
  FILE_NAME="$(date '+%Y%m%d-%H:%M:%S')"
  case "$1" in
  # Screenshots
  "fullscreen" | "fs")
    grim -g "$(slurp -o -r -c '#b48ead00')" - | satty --filename - --init-tool crop --output-filename "$HOME/Pictures/$FILE_NAME.png" --early-exit
    wl-copy "$HOME/Pictures/$FILE_NAME.png"
    echo "Created '$FILE_NAME.png' (unless an error occurred) and copied file name to clipboard."
    ;;
  "window" | "w")
    grim -g "$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)"" | jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"' | slurp -d -c '#b48eadff')" - | satty --filename - --init-tool crop --output-filename "$HOME/Pictures/$FILE_NAME.png" --early-exit
    wl-copy "$HOME/Pictures/$FILE_NAME.png"
    echo "Created '$FILE_NAME.png' (unless an error occurred) and copied file name to clipboard."
    ;;
  "area" | "manual" | "a" | "m")
    grim -g "$(slurp -d -c '#b48eadff')" - | satty --filename - --init-tool crop --output-filename "$HOME/Pictures/$FILE_NAME.png" --early-exit
    wl-copy "$FILE_NAME.png"
    echo "Created '$FILE_NAME.png' (unless an error occurred) and copied file name to clipboard."
    ;;
    # Video
  "record-fullscreen" | "rfs")
    wf-recorder -g "$(slurp -d -c '#b48eadff')" -f "$HOME/Videos/$FILE_NAME.mp4"
    wl-copy "$FILE_NAME.mp4"
    echo "Created '$FILE_NAME.mp4' (unless an error occurred) and copied file name to clipboard."
    ;;
  "record-window" | "rw")
    wf-recorder -g "$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)"" | jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"' | slurp -d -c '#b48eadff')" -f "$HOME/Videos/$FILE_NAME.mp4"
    wl-copy "$FILE_NAME.mp4"
    echo "Created '$FILE_NAME.mp4' (unless an error occurred) and copied file name to clipboard."
    ;;
  "record-area" | "record-manual" | "ra" | "rm")
    wf-recorder -g "$(slurp -d -c '#b48eadff')" -f "$HOME/Videos/$FILE_NAME.mp4"
    wl-copy "$FILE_NAME.mp4"
    echo "Created '$FILE_NAME.mp4' (unless an error occurred) and copied file name to clipboard."
    ;;
    # Conversion to GIF
  "convert-gif" | "cg")
    if [[ -z "$2" || -z $3 ]]; then
      echo "Error: No file name or target resolution width (e.g. 640) provided for conversion."
      exit 1
    fi
    ffmpeg -i "$2" \
      -vf "fps=$4,scale=$3:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
      -loop 0 "$2.gif"
    wl-copy "$2.gif"
    echo "Created '$2.gif' (unless an error occurred) and copied file name to clipboard."
    ;;
  "help" | "h" | "man")
    echo "Usage: screeny [command] ([file name]) ([width])"
    echo ""
    echo "Commands:"
    echo "  fullscreen, fs                            : Take a screenshot of the entire screen."
    echo "  window, w                                 : Take a screenshot of the active window."
    echo "  area, manual, a, m                        : Take a screenshot of a selected area."
    echo "  record-fullscreen, rfs                    : Record the entire screen."
    echo "  record-window, rw                         : Record the active window."
    echo "  record-area, record-manual, ra, rm        : Record a selected area."
    echo "  convert-gif, cg [file name] [width] [fps] : Convert a video to a GIF with a specified width. File name is"
    echo "                                              the file to convert. Will store GIF in same directory."
    echo "  help, h                                   : Display this help message."
    echo ""
    ;;
  # Error
  *)
    echo "Error: Command '$1' not recognised."
    notify-send "  Error: Command '$1' not recognised."
    ;;
  esac
}

screeny "$@"
