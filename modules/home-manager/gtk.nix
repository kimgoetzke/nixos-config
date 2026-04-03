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

      # Required if `home.stateVersion` is less than "26.05":
      gtk4.theme = config.gtk.theme;
    };
  };
}
