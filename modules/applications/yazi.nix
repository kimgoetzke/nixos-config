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
    };

    home.sessionVariables = {
      YAZI_CONFIG_HOME = "${userSettings.targetDirectory}/yazi";
    };

    home.file."${userSettings.relativeTargetDirectory}/yazi/yazi.toml" = {
      source = ./../../assets/configs/yazi/yazi.toml;
    };
  };
}
