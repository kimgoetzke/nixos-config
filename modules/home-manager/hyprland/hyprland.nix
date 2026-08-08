{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}: let
  cfg = config.hyprland;
  toLua = lib.generators.toLua {};
  mainMod = "SUPER";
  terminal = userSettings.emulator;
  bind = keys: dispatcher: "hl.bind(${toLua keys}, ${dispatcher})";
  bindWithOptions = keys: dispatcher: options: "hl.bind(${toLua keys}, ${dispatcher}, ${toLua options})";
  execBind = keys: command: bind keys "hl.dsp.exec_cmd(${toLua command})";
  directionName = direction:
    {
      d = "down";
      u = "up";
      l = "left";
      r = "right";
    }
    .${
      direction
    };
  focusBind = keys: direction: bind keys "hl.dsp.focus({ direction = ${toLua (directionName direction)} })";
  moveBind = keys: direction: bind keys "hl.dsp.window.move({ direction = ${toLua (directionName direction)} })";
  resizeBind = keys: x: y: bind keys "hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })";
  workspaceBind = keys: workspace: bind keys "hl.dsp.focus({ workspace = ${toLua (toString workspace)} })";
  moveToWorkspaceBind = keys: workspace: bind keys "hl.dsp.window.move({ workspace = ${toLua (toString workspace)}, follow = false })";

  execOnceCommands =
    [
      "hypridle" # Change to `systemctl --user enable --now hypridle.service` when using uwsm
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    ]
    ++ lib.optionals (userSettings.hyprland.bar != "quickshell") [
      "hyprlock"
      "swww-daemon"
      "swww img ${userSettings.targetDirectory}/wallpaper.png"
    ]
    ++ lib.optionals config.hyprland-waybar.enable [
      "mako" # Conflicts with hyprpanel which comes with a notification daemon
      "sleep 10 && ${userSettings.targetDirectory}/reload-ui.sh"
    ]
    ++ lib.optionals config.hyprland-hyprpanel.enable [
      "hyprpanel"
    ]
    ++ lib.optionals config.hyprland-noctalia.enable [
      "noctalia"
    ];

  luaExecOnce = lib.concatMapStringsSep "\n" (command: "  hl.exec_cmd(${toLua command})") execOnceCommands;

  baseBinds = [
    # General
    (execBind "${mainMod} + SHIFT + F1" "${userSettings.targetDirectory}/hyprland-keybindings.sh")
    (execBind "${mainMod} + SHIFT + F2" "${userSettings.targetDirectory}/main-monitor-detector.sh")
    (execBind "${mainMod} + SHIFT + F3" "wdisplays")
    (execBind "${mainMod} + SHIFT + F4" "${userSettings.targetDirectory}/toggle-performance-mode.sh")
    (execBind "${mainMod} + SHIFT + F5" "${userSettings.targetDirectory}/reload-ui.sh")

    # Apps
    (execBind "${mainMod} + N" "${terminal} -e nmtui")
    (execBind "${mainMod} + E" "nautilus")
    (execBind "${mainMod} + M" "nautilus")
    (execBind "${mainMod} + Y" "${terminal} -e yazi")
    (execBind "${mainMod} + F" "firefox")
    (execBind "${mainMod} + T" terminal)
    (execBind "${mainMod} + J" "jetbrains-toolbox")
    (execBind "${mainMod} + O" "obsidian")
    (execBind "${mainMod} + C" "code")
    (execBind "${mainMod} + Z" "zeditor")
    (execBind "${mainMod} + A" "aseprite")
    (execBind "${mainMod} + SHIFT + K" "${terminal} -e kalker")
    (execBind "${mainMod} + K" "${userSettings.targetDirectory}/rofi-calculator.sh")
    (execBind "${mainMod} + X" "kooha") # GIF screen recorder
    (execBind "${mainMod} + S" "hyprctl clients | awk '/class:/ {print $2}' | grep -q 'steam' && hyprctl dispatch closewindow steam || steam")
    (execBind "${mainMod} + SHIFT + C" "hyprpicker -f hex -a")

    # Screenshots
    (execBind "${mainMod} + SHIFT + P" "${userSettings.targetDirectory}/screeny.sh fullscreen") # Full screen and pipe into annotation tool
    (execBind "${mainMod} + SHIFT + bracketleft" "${userSettings.targetDirectory}/screeny.sh window") # Selected window and pipe into annotation tool
    (execBind "${mainMod} + SHIFT + bracketright" "${userSettings.targetDirectory}/screeny.sh area") # Manually select and pipe into annotation tool

    # Screen recording
    (execBind "${mainMod} + SHIFT + R" "${userSettings.targetDirectory}/screeny.sh record-area") # Manually select area and record

    # Volume
    (execBind "0x1008FF11" "wpctl set-volume @DEFAULT_SINK@ 5%-")
    (execBind "0x1008FF13" "wpctl set-volume @DEFAULT_SINK@ 5%+")
    (execBind "0x1008FF12" "wpctl set-mute @DEFAULT_SINK@ toggle")
    (execBind "XF86AudioMicMute" "wpctl set-mute @DEFAULT_SOURCE@ toggle")

    # Brightness
    (execBind "XF86MonBrightnessUp" "brightnessctl s +5%")
    (execBind "XF86MonBrightnessDown" "brightnessctl s 5%-")

    # Windows & workspaces
    (bind "${mainMod} + Q" "hl.dsp.window.float({ action = \"toggle\" })")
    (bind "${mainMod} + W" "hl.dsp.layout(\"togglesplit\")")
    (bind "${mainMod} + F11" "hl.dsp.window.fullscreen({ mode = \"fullscreen\" })")
    (bind "${mainMod} + CONTROL + SHIFT + P" "hl.dsp.window.pin()")
    (bind "${mainMod} + SHIFT + Q" "hl.dsp.window.close()")
    (bind "ALT + F4" "hl.dsp.window.close()")
    (focusBind "${mainMod} + down" "d")
    (focusBind "${mainMod} + up" "u")
    (focusBind "${mainMod} + left" "l")
    (focusBind "${mainMod} + right" "r")
    (moveBind "${mainMod} + SHIFT + down" "d")
    (moveBind "${mainMod} + SHIFT + up" "u")
    (moveBind "${mainMod} + SHIFT + left" "l")
    (moveBind "${mainMod} + SHIFT + right" "r")
    (bind "${mainMod} + CONTROL + S" "hl.dsp.workspace.toggle_special(\"magic\")")
    (bind "${mainMod} + mouse_down" "hl.dsp.focus({ workspace = \"e+1\" })")
    (bind "${mainMod} + mouse_up" "hl.dsp.focus({ workspace = \"e-1\" })")
    (resizeBind "${mainMod} + ALT + right" 50 0)
    (resizeBind "${mainMod} + ALT + left" (-50) 0)
    (resizeBind "${mainMod} + ALT + up" 0 (-50))
    (resizeBind "${mainMod} + ALT + down" 0 50)
    (workspaceBind "${mainMod} + code:49" 10) # $mainMod + ` = go to workspace 10
    (moveToWorkspaceBind "${mainMod} + SHIFT + code:49" 10) # $mainMod + SHIFT + ` = move active silently to workspace 10

    # Scrolling (layoutmsg binds are no-ops on non-scrolling workspaces)
    (bind "${mainMod} + CTRL + right" "hl.dsp.layout(\"colresize +conf\")") # Make column wider
    (bind "${mainMod} + CTRL + left" "hl.dsp.layout(\"colresize -conf\")") # Make column narrower
    (bind "${mainMod} + CTRL + F" "hl.dsp.layout(\"fit active\")") # Fit focused column to screen
    (bind "${mainMod} + CTRL + P" "hl.dsp.layout(\"promote\")") # Pop window into its own column
    (bind "${mainMod} + CTRL + up" "hl.dsp.layout(\"movewindowto u\")") # Move window up within column
    (bind "${mainMod} + CTRL + down" "hl.dsp.layout(\"movewindowto d\")") # Move window down within column
  ];

  quickshellBinds = lib.optionals (userSettings.hyprland.bar == "quickshell") [
    # Launchers & menus
    (execBind "${mainMod} + SPACE" "noctalia msg panel-toggle launcher")
    (execBind "${mainMod} + period" "noctalia msg panel-toggle launcher /emo")
    (execBind "${mainMod} + SHIFT + S" "noctalia msg settings-toggle")
    (execBind "${mainMod} + V" "noctalia msg panel-toggle clipboard")

    # Volume and brightness
    (execBind "XF86AudioRaiseVolume" "noctalia msg volume-up")
    (execBind "XF86AudioLowerVolume" "noctalia msg volume-down")
    (execBind "XF86AudioMute" "noctalia msg volume-mute")
    (execBind "XF86MonBrightnessUp" "noctalia msg brightness-up")
    (execBind "XF86MonBrightnessDown" "noctalia msg brightness-down")

    # Lock & power
    (execBind "${mainMod} + L" "noctalia msg session lock")
    (execBind "${mainMod} + CONTROL + SHIFT + Q" "noctalia msg panel-toggle session")
  ];

  nonQuickshellBinds = lib.optionals (userSettings.hyprland.bar != "quickshell") [
    # Launchers & menus
    (execBind "${mainMod} + SPACE" "pkill -x rofi || rofi -show-icons -show drun")
    (execBind "${mainMod} + period" "pkill -x rofi || rofi -show-icons -show emoji")

    # Lock & power
    (execBind "${mainMod} + CONTROL + SHIFT + Q" "pkill -x rofi || ${userSettings.targetDirectory}/power-menu.sh")
    (execBind "${mainMod} + L" "hyprlock")
    (execBind "switch:on:Lid Switch" "pidof hyprlock || hyprlock")

    # Clipboard
    (execBind "${mainMod} + SHIFT + V" "${userSettings.targetDirectory}/cliphist-helper.sh wipe")
    (execBind "${mainMod} + V" "${userSettings.targetDirectory}/cliphist-helper.sh open")
  ];

  workspaceBinds = builtins.concatLists (
    builtins.genList (
      x: let
        workspace = toString (x + 1);
        key = toString ((x + 1) - (((x + 1) / 10) * 10));
      in [
        (workspaceBind "${mainMod} + ${key}" workspace)
        (moveToWorkspaceBind "${mainMod} + SHIFT + ${key}" workspace)
      ]
    )
    10
  );

  mouseBinds = [
    (bindWithOptions "${mainMod} + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
    (bindWithOptions "${mainMod} + mouse:273" "hl.dsp.window.resize()" {mouse = true;})
  ];

  luaBinds = lib.concatStringsSep "\n" (baseBinds ++ quickshellBinds ++ nonQuickshellBinds ++ workspaceBinds ++ mouseBinds);
in {
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Wayland with Hyprland";
  };

  imports = [
    ./waybar.nix
    ./hyprpanel.nix
    ./noctalia.nix
    ./rofi.nix
    ./mako.nix
    ./cliphist.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./scripts.nix
    ./kanshi.nix
  ];

  config = lib.mkIf cfg.enable {
    rofi.enable = true;
    cliphist.enable = true;
    hypridle.enable = true;
    hyprlock.enable = userSettings.hyprland.bar != "quickshell";
    kanshi.enable = false;
    hyprland-waybar.enable = userSettings.hyprland.bar == "waybar";
    hyprland-hyprpanel.enable = userSettings.hyprland.bar == "hyprpanel";
    hyprland-noctalia.enable = userSettings.hyprland.bar == "quickshell";
    hyprland-hyprpaper.enable = false;
    mako.enable = config.hyprland-waybar.enable;

    home.packages = with pkgs;
      [
        polkit_gnome # A dbus session bus service used to bring up authentication dialogs
        cliphist # Clipboard manager
        wl-clipboard # Wayland clipboard manager, dependency of cliphist
        gvfs # Mount, trash, and other functionalities (for Thunar/Nautilus)
        hypridle # Idle manager
        hyprpicker # Colour picker
        brightnessctl # Tool to control brightness
      ]
      ++ lib.optionals (userSettings.hyprland.bar != "quickshell") [
        swww # Wallpaper daemon
      ]
      ++ lib.optionals config.hyprland-waybar.enable [
        libnotify # Notification daemon
        blueman # Bluetooth manager
        mako # Notification daemon
      ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      configType = "lua";
      extraConfig = ''
        local terminal = ${toLua terminal}

        hl.on("hyprland.start", function()
        ${luaExecOnce}
        end)

        hl.monitor({ output = "DP-2", mode = "preferred", position = "0x0", scale = 1, transform = 3 })
        hl.monitor({ output = "DP-3", mode = "2560x1600", position = "-1120x500", scale = 1 })
        hl.monitor({ output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579", mode = "preferred", position = "1440x500", scale = 1 })
        hl.monitor({ output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104", mode = "preferred", position = "3700x-840", scale = 1 })
        hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "4000x600", scale = 1 })

        hl.workspace_rule({ workspace = "1", monitor = ${toLua (
          if userSettings.hyprland.hasLeftMonitor
          then userSettings.hyprland.leftMonitor
          else userSettings.hyprland.externalMonitor
        )}, default = true, layout = "scrolling" })
        hl.workspace_rule({ workspace = "2", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104", default = true })
        hl.workspace_rule({ workspace = "2", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579", default = true, layout = "scrolling", layout_opts = { direction = "left" } })
        hl.workspace_rule({ workspace = "3", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104" })
        hl.workspace_rule({ workspace = "3", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579" })
        hl.workspace_rule({ workspace = "4", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104" })
        hl.workspace_rule({ workspace = "4", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579" })
        hl.workspace_rule({ workspace = "5", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104" })
        hl.workspace_rule({ workspace = "5", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579" })
        hl.workspace_rule({ workspace = "6", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104" })
        hl.workspace_rule({ workspace = "6", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579" })
        hl.workspace_rule({ workspace = "7", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104" })
        hl.workspace_rule({ workspace = "7", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579" })
        hl.workspace_rule({ workspace = "8", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104" })
        hl.workspace_rule({ workspace = "8", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579" })
        hl.workspace_rule({ workspace = "9", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M32QC 22030B001104" })
        hl.workspace_rule({ workspace = "9", monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579" })
        hl.workspace_rule({ workspace = "10", monitor = "eDP-1", layout = "scrolling" })

        hl.config({
          input = {
            kb_layout = "gb",
            touchpad = {
              natural_scroll = true,
              disable_while_typing = false,
            },
            sensitivity = 0.1,
            scroll_method = "on_button_down",
            scroll_button = 274,
          },
          general = {
            gaps_in = 5,
            gaps_out = 15,
            border_size = 3,
            layout = "dwindle",
            allow_tearing = false,
          },
          decoration = {
            inactive_opacity = 1.0,
            rounding = 7,
            blur = {
              enabled = true,
              size = 12,
              passes = 2,
            },
            shadow = {
              enabled = false,
              range = 8,
              render_power = 3,
            },
          },
          animations = {
            enabled = true,
          },
          dwindle = {
            preserve_split = true,
          },
          master = {
            new_status = "master",
          },
          scrolling = {
            column_width = 1.0,
            fullscreen_on_one_column = true,
            focus_fit_method = 0,
            follow_focus = true,
            direction = "right",
            explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
          },
          misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
          },
        })

        hl.curve("easeOutQuart", { type = "bezier", points = { { 0.25, 1 }, { 0.25, 1 } } })
        hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "easeOutQuart" })
        hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 60%" })
        hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "easeOutQuart" })
        hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "easeOutQuart" })

        hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
        hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
        hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", scale = 1.5, action = "fullscreen" })

        hl.window_rule({ name = "aseprite-tile", match = { initial_class = "Aseprite" }, tile = true })
        hl.window_rule({ name = "firefox-sharing-float", match = { title = "^(Firefox — Sharing Indicator)$" }, float = true })
        hl.window_rule({ name = "firefox-sharing-border", match = { title = "^(Firefox — Sharing Indicator)$" }, border_size = 0 })
        hl.window_rule({ name = "firefox-sharing-rounding", match = { title = "^(Firefox — Sharing Indicator)$" }, rounding = 0 })
        hl.window_rule({ name = "pip-float", match = { title = "^(Picture-in-Picture)$" }, float = true })
        hl.window_rule({ name = "pip-pin", match = { title = "^(Picture-in-Picture)$" }, pin = true })
        hl.window_rule({ name = "save-file-float", match = { title = "^(Save File)$" }, float = true })
        hl.window_rule({ name = "save-file-pin", match = { title = "^(Save File)$" }, pin = true })
        hl.window_rule({ name = "share-dialog-float", match = { title = "^(Select what to share.*)$" }, float = true })
        hl.window_rule({ name = "blueman-title-float", match = { title = "^(.*blueman-manager.*)$" }, float = true })
        hl.window_rule({ name = "blueman-class-float", match = { class = "^(.*blueman-manager.*)$" }, float = true })
        hl.window_rule({ name = "blueman-title-center", match = { title = "^(.*blueman-manager.*)$" }, center = true })
        hl.window_rule({ name = "blueman-class-center", match = { class = "^(.*blueman-manager.*)$" }, center = true })
        hl.window_rule({ name = "rider-welcome-float", match = { title = "^(Welcome to JetBrains Rider)$" }, float = true })
        hl.window_rule({ name = "webstorm-welcome-float", match = { title = "^(Welcome to WebStorm)$" }, float = true })
        hl.window_rule({ name = "intellij-welcome-float", match = { title = "^(Welcome to IntelliJ.*)$" }, float = true })
        hl.window_rule({ name = "rustrover-welcome-float", match = { title = "^(Welcome to RustRover)$" }, float = true })
        hl.window_rule({ name = "jetbrains-toolbox-class-float", match = { class = "jetbrains-toolbox" }, float = true })
        hl.window_rule({ name = "jetbrains-toolbox-title-float", match = { initial_title = "Toolbox" }, float = true })
        hl.window_rule({ name = "jetbrains-toolbox-class-center", match = { class = "jetbrains-toolbox" }, center = true })
        hl.window_rule({ name = "jetbrains-toolbox-title-center", match = { initial_title = "Toolbox" }, center = true })
        hl.window_rule({ name = "jetbrains-toolbox-move", match = { class = "jetbrains-toolbox" }, move = "(cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5))" })
        hl.window_rule({ name = "jetbrains-commit-float", match = { class = "^jetbrains-.*$", title = "^Commit:.*$" }, float = true })
        hl.window_rule({ name = "jetbrains-toolbox-no-initial-focus", match = { class = "jetbrains-toolbox", initial_title = "win(.*)" }, no_initial_focus = true })
        hl.window_rule({ name = "jetbrains-idea-no-initial-focus", match = { class = "jetbrains-idea", initial_title = "win(.*)" }, no_initial_focus = true })
        hl.window_rule({ name = "jetbrains-rustrover-no-initial-focus", match = { class = "jetbrains-rustrover", initial_title = "win(.*)" }, no_initial_focus = true })
        hl.window_rule({ name = "jetbrains-empty-initial-title-no-initial-focus", match = { class = "^(jetbrains-)(.*)", initial_title = "^$" }, no_initial_focus = true })
        hl.window_rule({ name = "jetbrains-empty-title-no-focus", match = { class = "^(jetbrains-)(.*)", title = "^$" }, no_focus = true })
        hl.window_rule({ name = "mooplas-float", match = { title = "^Mooplas$" }, float = true })
        hl.window_rule({ name = "mooplas-center", match = { title = "^Mooplas$" }, center = true })
        hl.window_rule({ name = "rusteroids-float", match = { title = "^(Rusteroids)$" }, float = true })
        hl.window_rule({ name = "rusteroids-center", match = { title = "^(Rusteroids)$" }, center = true })
        hl.window_rule({ name = "idle-inhibit-fullscreen", match = { class = ".*" }, idle_inhibit = "fullscreen" })

        hl.layer_rule({ name = "rofi-blur", match = { namespace = "rofi" }, blur = true })
        hl.layer_rule({ name = "rofi-dim", match = { namespace = "rofi" }, dim_around = true })
        hl.layer_rule({ name = "noctalia-blur", match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$" }, blur = true })
        hl.layer_rule({ name = "noctalia-blur-popups", match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$" }, blur_popups = true })
        hl.layer_rule({ name = "noctalia-ignore-alpha", match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$" }, ignore_alpha = 0.5 })

        ${luaBinds}
      '';
    };
  };
}
