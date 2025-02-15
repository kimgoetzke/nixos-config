{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.gtk-settings;
in {
  options.gtk-settings = {
    enable = lib.mkEnableOption "Use GTK theme and icons";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      # Currently this is only working partially, most of the theme is not applied. I tried disabling the
      # stylix.target.gtk and disabling the icon theme above but that stopped home-manager from starting.
      #stylix.targets.gtk.enable = false;
      theme = lib.mkForce {
        package = pkgs.nordic;
        name = "Nordic";
      };
    };
  };
}
