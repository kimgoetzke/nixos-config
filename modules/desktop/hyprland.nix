{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.de-hyprland;
in {
  options.de-hyprland = {
    enable = lib.mkEnableOption "Enable Wayland with Hyprland as desktop environment";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };
}
