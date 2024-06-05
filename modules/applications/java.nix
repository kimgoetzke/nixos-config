{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.java;
in {
  options.java = {
    enable = lib.mkEnableOption "Enable packages for Java development";
  };

  config = lib.mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = pkgs.jdk21;
    };
  };
}
