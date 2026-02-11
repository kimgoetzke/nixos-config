{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.tuigreet;
  # Merge stderr and stdout, append to log file and discard output to avoid showing it in the greeter
  command = "'sh -c \"exec start-hyprland 2>&1 | tee -a /tmp/hyprland-$USER.log >/dev/null\"'";
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
