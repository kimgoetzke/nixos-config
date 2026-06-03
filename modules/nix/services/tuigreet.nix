{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.tuigreet;
  # Merge stderr and stdout, append to log file and discard output to avoid showing it in the greeter
  sessionCommand = pkgs.writeShellScript "start-hyprland-logged" ''
    exec start-hyprland 2>&1 | tee -a /tmp/hyprland-"$USER".log >/dev/null
  '';
  command = lib.escapeShellArgs [
    "${pkgs.tuigreet}/bin/tuigreet"
    "--time"
    "--remember"
    "--asterisks"
    "--theme"
    "button=cyan;time=cyan"
    "--cmd"
    sessionCommand
  ];
in {
  options.tuigreet = {
    enable = lib.mkEnableOption "Enable tuigreet, a terminal-based greeter for greetd";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = command;
          user = "greeter";
        };
      };
    };
  };
}
