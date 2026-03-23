{
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
      settings = {
        user = {
          name = userSettings.userFullName;
          email = userSettings.userEmail;
        };
        init.defaultBranch = "main";
        safe.directory = [
          "/home/${userSettings.user}/projects"
        ];
      };
      settings = {
        credential.helper = "!/run/current-system/sw/bin/gh auth git-credential";
      };

      # Required if `home.stateVersion` is less than "26.05":
      signing.format = "openpgp";
    };
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "https";
      };
    };
  };
}
