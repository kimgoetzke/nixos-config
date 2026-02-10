{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.tuigreet;
  command = "start-hyprland";
in {
  options.tuigreet = {
    enable = lib.mkEnableOption "Enable tuigreet, a terminal-based greeter for greetd";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --theme 'button=cyan;time=cyan' --cmd ${command}";
          user = "greeter";
        };
        # initial_session = {
        #   command = "${command}";
        #   user = "${userSettings.user}";
        # };
      };
    };
  };
}
