# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/control-center" = {
      last-panel = "multitasking";
      window-state = mkTuple [980 640 false];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilities" "YaST" "Pardus"];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" "org.gnome.Snapshot.desktop" "org.gnome.SystemMonitor.desktop" "xterm.desktop" "yelp.desktop" "org.gnome.clocks.desktop" "cups.desktop"];
      categories = ["X-GNOME-Utilities"];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///nix/store/fry2di1hxvnd00lg45gk5vjx1jnfjzr2-wallpaper_abstract_nord4x.png";
      picture-uri-dark = "file:///nix/store/fry2di1hxvnd00lg45gk5vjx1jnfjzr2-wallpaper_abstract_nord4x.png";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(mkTuple ["xkb" "gb"])];
      xkb-options = ["terminate:ctrl_alt_bksp" "lv3:ralt_switch"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "default";
      cursor-size = 32;
      cursor-theme = "Bibata-Modern-Ice";
      document-font-name = "DejaVu Serif  11";
      enable-hot-corners = false;
      font-name = "DejaVu Sans 12";
      gtk-theme = "adw-gtk3";
      monospace-font-name = "JetBrainsMono Nerd Font 12";
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 3;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/shell" = {
      disabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = ["clipboard-history@alexsaveau.dev" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "space-bar@luchrioh"];
      favorite-apps = ["firefox.desktop" "org.gnome.Nautilus.desktop" "obsidian.desktop" "Alacritty.desktop"];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "46.2";
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [];
    };

    "org/gnome/shell/extensions/clipboard-history" = {
      cache-size = 100;
      clear-history = ["<Shift><Control>l"];
      disable-down-arrow = true;
      display-mode = 0;
      history-size = 100;
      move-item-first = true;
      notify-on-copy = false;
      private-mode = false;
      toggle-menu = ["<Shift><Control>v"];
      toggle-private-mode = ["<Shift><Control>p"];
      window-width-percentage = 40;
    };

    "org/gnome/shell/extensions/space-bar/appearance" = {
      active-workspace-border-color = "rgba(235,203,139,0.523333)";
      active-workspace-border-radius = 3;
      active-workspace-border-width = 2;
      active-workspace-padding-h = 8;
      active-workspace-padding-v = 1;
      empty-workspace-border-radius = 3;
      empty-workspace-border-width = 2;
      empty-workspace-padding-h = 8;
      empty-workspace-padding-v = 1;
      inactive-workspace-border-radius = 3;
      inactive-workspace-border-width = 2;
      inactive-workspace-padding-h = 8;
      inactive-workspace-padding-v = 1;
      workspaces-bar-padding = 1;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = false;
      show-empty-workspaces = true;
      toggle-overview = true;
    };

    "org/gnome/shell/extensions/space-bar/state" = {
      version = 27;
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Stylix";
    };

    "org/gnome/shell/keybindings" = {
      screenshot = ["<Shift><Control><Alt>s"];
      screenshot-window = ["<Shift><Control>s"];
      show-screenshot-ui = ["<Super>bracketleft"];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gtk/gtk4/settings/color-chooser" = {
      custom-colors = [(mkTuple [0.9215686321258545 0.7960784435272217 0.545098066329956 0.5233333110809326]) (mkTuple [1.0 1.0 1.0 0.5]) (mkTuple [0.9215686321258545 0.7960784435272217 0.545098066329956 1.0]) (mkTuple [0.0 0.0 0.0 0.0])];
      selected-color = mkTuple [true 0.9215686321258545 0.7960784435272217 0.545098066329956 0.5233333110809326];
    };
  };
}
