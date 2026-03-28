{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.zed;
in {
  options.zed = {
    enable = lib.mkEnableOption "Enable Zed Editor";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zed-editor
    ];
  };
}
