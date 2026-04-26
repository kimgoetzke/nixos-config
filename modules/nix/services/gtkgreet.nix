{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}:
let
  cfg = config.gtkgreet;
  wallpaperImage = "${userSettings.targetDirectory}/wallpaper.png";
  sessionCommand = pkgs.writeShellScript "hyprland-session" ''
    exec ${pkgs.hyprland}/bin/start-hyprland 2>&1 | tee -a /tmp/hyprland-"$USER".log >/dev/null
  '';
  greeterSessionCommand = pkgs.writeShellScript "greetd-hyprland-session" ''
    exec ${pkgs.hyprland}/bin/Hyprland --config ${hyprlandConfig} >/dev/null 2>&1
  '';
  gtkgreetCss = pkgs.writeText "gtkgreet.css" ''
    window {
      background-color: #191A1C;
      background-image: url("${wallpaperImage}");
      background-position: center;
      background-repeat: no-repeat;
      background-size: cover;
    }

    box#body {
      background-color: rgba(36,38,43,0.9);
      border: 1px solid #393B40;
      border-radius: 18px;
      box-shadow: 0 18px 48px rgba(25,26,28,0.45);
      padding: 28px 32px;
    }

    label {
      color: #DFE1E5;
      font-weight: 600;
    }

    entry,
    button,
    button.suggested-action,
    button.combo,
    combobox button {
      min-height: 40px;
      border-radius: 14px;
    }

    entry {
      background-color: #191A1C;
      color: #DFE1E5;
      border: 1px solid #393B40;
      padding: 0 14px;
    }

    entry:focus {
      border-color: #56A8F5;
      box-shadow: 0 0 0 3px rgba(86,168,245,0.18);
    }

    button,
    button.suggested-action,
    button.combo,
    combobox button {
      background-color: #2B2D30;
      color: #DFE1E5;
      border: 1px solid #393B40;
      background-image: none;
      box-shadow: none;
      text-shadow: none;
      padding: 0 18px;
      font-weight: 700;
    }

    /*
     * Temporarily disabled for GTK3 compliance testing.
     * These more exotic combobox layout selectors may be valid in some GTK
     * node trees, but they are the most likely source of stylesheet rejection
     * or selector mismatch in gtkgreet.
     */
    /*
    combobox,
    combobox box.linked,
    combobox box.linked:not(.vertical) {
      background-color: transparent;
      background-image: none;
      border: none;
      border-radius: 0;
      box-shadow: none;
      padding: 0;
      margin: 0;
    }

    combobox box.linked:not(.vertical) > button,
    combobox box.linked:not(.vertical) > entry {
      margin: 0;
    }

    combobox box.linked:not(.vertical) > button:first-child,
    combobox box.linked:not(.vertical) > entry:first-child {
      border-top-right-radius: 0;
      border-bottom-right-radius: 0;
    }

    combobox box.linked:not(.vertical) > button:last-child,
    combobox box.linked:not(.vertical) > entry:last-child {
      border-top-left-radius: 0;
      border-bottom-left-radius: 0;
    }

    combobox box.linked:not(.vertical) > button + button,
    combobox box.linked:not(.vertical) > entry + button,
    combobox box.linked:not(.vertical) > button + entry {
      margin-left: 0;
      border-left-width: 0;
    }

    combobox box.linked:not(.vertical) > button:last-child {
      min-width: 44px;
      padding: 0 12px;
    }
    */

    combobox arrow {
      color: #DFE1E5;
    }

    button:hover,
    button.suggested-action:hover,
    button.combo:hover,
    combobox button:hover {
      background-color: #31343A;
      border-color: #4B4E55;
    }

    button:focus,
    button.suggested-action:focus,
    button.combo:focus,
    combobox button:focus {
      border-color: #56A8F5;
      box-shadow: 0 0 0 3px rgba(86,168,245,0.18);
    }

    button:active,
    button:checked,
    button.suggested-action,
    button.suggested-action:active,
    button.suggested-action:checked,
    button.combo:active,
    button.combo:checked,
    combobox button:active,
    combobox button:checked,
    combobox button:checked {
      background-color: #393B40;
      color: #DFE1E5;
      border-color: #4B4E55;
    }

    button:active:hover,
    button:checked:hover,
    button.suggested-action:hover,
    button.suggested-action:active:hover,
    button.suggested-action:checked:hover,
    button.combo:active:hover,
    button.combo:checked:hover,
    combobox button:checked:hover {
      background-color: #43464D;
      border-color: #565A62;
    }

    /* Temporarily simplified for GTK3 compliance testing. */
    /*
    menu,
    popover contents {
      background-color: #24262B;
      color: #DFE1E5;
      border: 1px solid #393B40;
      border-radius: 16px;
    }

    menuitem,
    modelbutton {
      min-height: 38px;
      border-radius: 12px;
      color: #DFE1E5;
      padding: 0 12px;
    }

    menuitem:hover,
    menuitem:focus,
    modelbutton:hover,
    modelbutton:focus,
    row:selected {
      background-color: #DFE1E5;
      color: #191A1C;
    }
    */
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
      disable_watchdog_warning = true
    }

    debug {
      disable_logs = true
    }

    exec-once = ${greeterCommand}
  '';
in
{
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
