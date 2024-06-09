{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/Console" = {
      last-window-maximised = false;
      last-window-size = mkTuple [1280 688];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilities" "YaST" "Pardus"];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" "cups.desktop" "yelp.desktop" "xterm.desktop" "org.gnome.clocks.desktop" "org.gnome.Totem.desktop"];
      categories = ["X-GNOME-Utilities"];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(mkTuple ["xkb" "gb"])];
      xkb-options = ["terminate:ctrl_alt_bksp" "lv3:ralt_switch"];
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
      disabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = ["clipboard-history@alexsaveau.dev" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
      favorite-apps = ["firefox.desktop" "org.gnome.Nautilus.desktop" "obsidian.desktop" "Alacritty.desktop"];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "46.2";
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

    "org/gnome/shell/keybindings" = {
      screenshot = ["<Shift><Control><Alt>s"];
      screenshot-window = ["<Shift><Control>s"];
      show-screenshot-ui = ["<Super>bracketleft"];
    };
  };
}
