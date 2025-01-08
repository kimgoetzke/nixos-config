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
    echo "Created '$HOME/Videos/$FILE_NAME.mp4' (unless an error occurred) and copied file name to clipboard."
    echo "Wanna convert to GIF?"
    echo "- Use 'screeny cgm $FILE_NAME.mp4 1440 16' for maximum quality, for example."
    echo "- Use 'screeny cgc $FILE_NAME.mp4 800 10 32' for reduced file size, for example."
    ;;
  "record-window" | "rw")
    wf-recorder -g "$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)"" | jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"' | slurp -d -c '#b48eadff')" -f "$HOME/Videos/$FILE_NAME.mp4"
    wl-copy "$FILE_NAME.mp4"
    echo "Created '$HOME/Videos/$FILE_NAME.mp4' (unless an error occurred) and copied file name to clipboard."
    echo "Wanna convert to GIF?"
    echo "- Use 'screeny cgm $FILE_NAME.mp4 800 16' for maximum quality, for example."
    echo "- Use 'screeny cgc $FILE_NAME.mp4 800 10 32' for reduced file size, for example."
    ;;
  "record-area" | "record-manual" | "ra" | "rm")
    wf-recorder -g "$(slurp -d -c '#b48eadff')" -f "$HOME/Videos/$FILE_NAME.mp4"
    wl-copy "$FILE_NAME.mp4"
    echo "Created '$HOME/Videos/$FILE_NAME.mp4' (unless an error occurred) and copied file name to clipboard."
    echo "Wanna convert to GIF?"
    echo "- Use 'screeny cgm $FILE_NAME.mp4 800 16' for maximum quality, for example."
    echo "- Use 'screeny cgc $FILE_NAME.mp4 800 10 32' for reduced file size."
    ;;
  # Conversion to GIF
  "convert-gif-max" | "cgm")
    if [[ -z "$2" || -z $3 ]]; then
      echo "Error: No file name, target resolution width (e.g. 640), or frame rate provided for conversion."
      exit 1
    fi
    ffmpeg -i "$2" \
      -vf "fps=$4,scale=$3:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
      -loop 0 "$2.gif"
    wl-copy "$2.gif"
    echo "Created '$2.gif' (unless an error occurred) and copied file name to clipboard."
    ;;
  "convert-gif-custom" | "cgc")
      if [[ -z "$2" || -z "$3" || -z "$4" || -z "$5"  ]]; then
        echo "Error: At least one required parameter is missing. Use with: [file name] [width] [fps] [colours]."
        exit 1
      fi
      ffmpeg -i "$2.mp4" \
        -vf "fps=$4,scale=$3:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=$5[p];[s1][p]paletteuse=dither=bayer" \
        -loop 0 "$2.gif"
      wl-copy "$2.gif"
      echo "Created '$2.gif' (unless an error occurred) and copied file name to clipboard."
      ;;
  # Conversion from OBS to MOV
  "convert-obs" | "cobs")
    if [[ -z "$2" ]]; then
      echo "Error: No file name provided for conversion."
      exit 1
    fi
    ffmpeg -i "$2" -c:v dnxhd -profile:v dnxhr_hq -c:a pcm_s16le -pix_fmt yuv422p "$2.mov"
    echo "Created '$2.mov' (unless an error occurred)."
    ;;
  "help" | "h" | "man")
    echo "Usage: screeny [command] ([file name]) ([width]) ([fps]) ([colours])"
    echo ""
    echo "Commands:"
    echo "  fullscreen, fs                            : Take a screenshot of the entire screen."
    echo "  window, w                                 : Take a screenshot of the active window."
    echo "  area, manual, a, m                        : Take a screenshot of a selected area."
    echo "  record-fullscreen, rfs                    : Record the entire screen."
    echo "  record-window, rw                         : Record the active window."
    echo "  record-area, record-manual, ra, rm        : Record a selected area."
    echo "  convert-gif-max,"
    echo "  cgm [file name] [width] [fps]             : Convert a video to a max quality GIF with a specified width and"
    echo "                                              FPS. Will store GIF in same directory as source file location."
    echo "  convert-gif-custom,"
    echo "  cgc [file name] [width] [fps] [colours]   : Convert a video to a GIF. Specify width, FPS, and max. colours"
    echo "                                              used when generating colour palette (defaults to 64)."
    echo "                                              Will store GIF in same directory as source file location."
    echo "  convert-obs, cobs [file name]             : Convert an OBS recording to a Davinci Resolve compatible MOV."
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
