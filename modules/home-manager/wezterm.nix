{
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.wezterm;
in {
  options.wezterm = {
    enable = lib.mkEnableOption "Enable Wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    home.sessionVariables = {
      WEZTERM_CONFIG_FILE = "${userSettings.targetDirectory}/wezterm.lua";
    };

    home.file."${userSettings.relativeTargetDirectory}/wezterm.lua" = {
      source = ./../../assets/configs/wezterm/wezterm.lua;
    };
  };
}
