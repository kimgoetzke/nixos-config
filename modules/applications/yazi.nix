{
  config,
  inputs,
  lib,
  ...
}: {
  options = {
    yazi.enable = lib.mkEnableOption "Enable Yazi, the terminal-based file manager";
  };

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
      # TODO: Add https://github.com/grappas/wl-clipboard.yazi
      # plugins = [
      #   {
      #     name = "yazi";
      #     enable = true;
      #   }
      # ];
      plugins = {
        max-preview = "${inputs.yazi-plugins}/max-preview.yazi";
        smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
        wl-clipboard = "${inputs.yazi-plugins-wl-clipboard}";
      };
      keymap = {
        manager.prepend_keymap = [
          {
            on = "T";
            run = "plugin max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "<C-y>";
            run = "plugin wl-clipboard";
            desc = "Copy to wl-clipboard";
          }
        ];
      };
    };

    home.sessionVariables = {
      YAZI_CONFIG_HOME = "~/.config/yazi";
    };

    home.file.".config/yazi/yazi.toml" = {
      source = ./../../assets/configs/yazi/yazi.toml;
    };

    home.file.".config/yazi/open-with-rofi.sh" = {
      text = ''
        #!/usr/bin/env bash

        file="$1"
        if [ ! -f "$file" ]; then
            echo "File does not exist: $file"
            notify-send "Error" "File does not exist: $file"
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
            notify-send "Cancelled" "No application selected"
            exit 1
        fi

        echo "Attempting to open [$file] with [$selected_app]"
        "$selected_app" "$file"
      '';
      executable = true;
    };
  };
}
