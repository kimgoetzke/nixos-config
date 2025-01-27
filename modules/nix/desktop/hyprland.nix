{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
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
    services.getty.autologinUser = userSettings.user; # Auto-login user
    services.power-profiles-daemon.enable = true; # Required for hyprpanel battery module
    services.upower.enable = true; # Required for hyprpanel battery module
  };
}
