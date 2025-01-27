{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.git;
in {
  options.git = {
    enable = lib.mkEnableOption "Enable Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = userSettings.userFullName;
      userEmail = userSettings.userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = [
          "/home/${userSettings.user}/projects"
        ];
      };
    };
  };
}
