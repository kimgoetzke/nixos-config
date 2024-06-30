{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    cliphist.enable = lib.mkEnableOption "Enable cliphist";
  };
  config = lib.mkIf config.rofi.enable {
    services.cliphist.enable = true;
    services.cliphist.extraOptions = [
      "-max-dedupe-search"
      "100"
      "-max-items"
      "100"
    ];
    home.file."${userSettings.relativeTargetDirectory}/cliphist-helper.sh" = {
      text = ''
        #!/usr/bin/env bash
        if [[ "$1" == "open" ]]; then
          cliphist list | rofi -dmenu -theme-str "window { location: northeast; anchor: northeast; y-offset: 5; x-offset: -60; } inputbar { children: [textbox-prompt-colon, entry]; }" | cliphist decode | wl-copy
        fi

        if [[ "$1" == "wipe" ]]; then
          cliphist wipe
          notify-send "   Wiped clipboard history"
        fi

        if [[ "$1" == "remove" ]]; then
          cliphist list | rofi -dmenu -theme-str "window { location: northeast; anchor: northeast; y-offset: 5; x-offset: -60; } inputbar { children: [textbox-prompt-colon, entry]; }" | cliphist delete
          notify-send "   Removed selected item from clipboard history"
        fi
      '';
      executable = true;
    };
    home.file.".config/cliphist/cliphist-rofi-img" = {
      # Required to work with rofi and images
      text = ''
        #!/usr/bin/env bash

        tmp_dir="/tmp/cliphist"
        rm -rf "$tmp_dir"

        if [[ -n "$1" ]]; then
            cliphist decode <<<"$1" | wl-copy
            exit
        fi

        mkdir -p "$tmp_dir"

        read -r -d '''' prog <<EOF
        /^[0-9]+\s<meta http-equiv=/ { next }
        match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
            system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
            print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
            next
        }
        1
        EOF
        cliphist list | gawk "$prog"
      '';
      executable = true;
    };
  };
}
