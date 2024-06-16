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
    enable = lib.mkEnableOption "Enable Hyprland related programmes/services in addition to home-manager configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.thunar.enable = true; # File manager
    programs.xfconf.enable = true; # Xfce configuration to allow storing preferences
    services.tumbler.enable = true; # Thumbnail support for images
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.getty.autologinUser = config.userSettings.userName; # Auto-login user
  };
}
