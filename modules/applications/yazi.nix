{
  config,
  lib,
  userSettings,
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
    };

    home.sessionVariables = {
      YAZI_CONFIG_HOME = "${userSettings.targetDirectory}/yazi";
    };

    home.file."${userSettings.relativeTargetDirectory}/yazi/yazi.toml" = {
      source = ./../../assets/configs/yazi/yazi.toml;
    };

    # TODO: Use or remove
    home.file."${userSettings.relativeTargetDirectory}/yazi/open-with-rofi.sh" = {
      text = ''
        #!/bin/bash

        file="$1"
        if [ ! -f "$file" ]; then
            notify-send "Error" "File does not exist: $file"
            exit 1
        fi

        app=$(rofi -show-icons -show drun)
        if [ -z "$app" ]; then
            notify-send "Cancelled" "No application selected"
            exit 1
        fi

        "$app" "$file"
      '';
    };
  };
}
