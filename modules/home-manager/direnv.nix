{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.direnv;
in {
  options.direnv = {
    enable = lib.mkEnableOption "Enable direnv, a tool that loads and unloads environments depending on the current directory";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
