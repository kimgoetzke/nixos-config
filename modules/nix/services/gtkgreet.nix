{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.gtkgreet;
  sessionCommand = pkgs.writeShellScript "hyprland-session" ''
    exec ${pkgs.hyprland}/bin/start-hyprland 2>&1 | tee -a /tmp/hyprland-"$USER".log >/dev/null
  '';
  greeterSessionCommand = pkgs.writeShellScript "greetd-hyprland-session" ''
    exec ${pkgs.hyprland}/bin/start-hyprland -- --config ${hyprlandConfig} >/dev/null 2>&1
  '';
  gtkgreetCss = pkgs.writeText "gtkgreet.css" ''
    window {
      background-color: #191A1C;
    }

    box#body {
      background-color: #1F2024;
      border: 1px solid #393B40;
      border-radius: 8px;
      padding: 32px 48px;
    }

    label {
      color: #BCBEC4;
    }

    entry {
      background-color: #2B2D30;
      color: #BCBEC4;
      border: 1px solid #393B40;
      border-radius: 4px;
    }

    entry:focus {
      border-color: #56A8F5;
    }

    button {
      background-color: #2B2D30;
      color: #BCBEC4;
      border: 1px solid #393B40;
      border-radius: 4px;
      padding: 6px 16px;
    }

    button:hover {
      background-color: #393B40;
    }

    combobox button {
      background-color: #2B2D30;
      color: #BCBEC4;
    }
  '';
  greeterCommand = pkgs.writeShellScript "gtkgreet-hyprland" ''
    ${pkgs.gtkgreet}/bin/gtkgreet -l -s ${gtkgreetCss} -c ${sessionCommand}
    ${pkgs.hyprland}/bin/hyprctl dispatch exit
  '';
  hyprlandConfig = pkgs.writeText "greetd-hyprland.conf" ''
    env = XDG_SESSION_TYPE,wayland
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = WLR_NO_HARDWARE_CURSORS,1

    monitor = ,preferred,auto,1

    input {
      kb_layout = gb
    }

    general {
      border_size = 0
      gaps_in = 0
      gaps_out = 0
    }

    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      force_default_wallpaper = 0
    }

    debug {
      disable_logs = true
    }

    exec-once = ${greeterCommand}
  '';
in {
  options.gtkgreet = {
    enable = lib.mkEnableOption "Enable gtkgreet, a graphical greeter for greetd hosted in Hyprland";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${greeterSessionCommand}";
          user = "greeter";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
