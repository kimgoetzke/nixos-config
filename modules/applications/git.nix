{
  pkgs,
  inputs,
  config,
  lib,
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
      userName = "Kim Goetzke";
      userEmail = "kbgoetzke@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = [
          "/home/kgoe/projects"
        ];
      };
    };
  };
}
