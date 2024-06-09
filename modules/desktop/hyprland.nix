{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.de-hyperland;
in {
  options.de-hyperland = {
    enable = lib.mkEnableOption "Enable Wayland with Hyprland as desktop environment";
  };

  config = lib.mkIf cfg.enable {
    # TODO: Add configuration here
  };
}
