{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.tuigreet;
in {
  options.tuigreet = {
    enable = lib.mkEnableOption "Enable tuigreet, a terminal-based greeter for greetd";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd start-hyrpland";
          user = "${userSettings.user}";
        };
      };
    };
  };
}
