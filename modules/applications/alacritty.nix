{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.alacritty;
in {
  options.alacritty = {
    enable = lib.mkEnableOption "Enable Alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window.opacity = lib.mkForce 0.75;
      };
    };
  };
}
