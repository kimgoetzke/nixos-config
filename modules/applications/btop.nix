{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.btop;
in {
  options.btop = {
    enable = lib.mkEnableOption "Enable btop, a terminal-based resource monitor";
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
  };
}
