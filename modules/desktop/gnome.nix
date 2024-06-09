{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.de-gnome;
in {
  options.de-gnome = {
    enable = lib.mkEnableOption "Enable X11 with GNOME as desktop environment";
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };

    # Exclude packages that no one needs
    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
        gnome-text-editor
        gedit # text editor
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gnome-terminal
        gnome-weather
        gnome-music
        gnome-contacts
        gnome-characters
        gnome-calendar
        gnome-maps
        simple-scan
        epiphany # web browser
        geary # email client
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
  };
}
