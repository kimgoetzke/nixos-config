{lib, ...}: {
  "org/gnome/desktop/app-folders" = {
    folder-children = ["Utilities" "YaST" "Pardus"];
  };

  "org/gnome/desktop/app-folders/folders/Utilities" = {
    apps = ["gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" "org.gnome.Snapshot.desktop" "org.gnome.SystemMonitor.desktop" "xterm.desktop" "yelp.desktop" "org.gnome.clocks.desktop" "cups.desktop"];
    categories = ["X-GNOME-Utilities"];
    name = "X-GNOME-Utilities.directory";
    translate = true;
  };

  "org/gnome/desktop/input-sources" = {
    sources = [(lib.hm.gvariant.mkTuple ["xkb" "gb"])];
    xkb-options = ["terminate:ctrl_alt_bksp" "lv3:ralt_switch"];
  };

  "org/gnome/desktop/privacy" = {
    old-files-age = lib.hm.gvariant.mkUint32 30;
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

  "org/gnome/desktop/interface" = {
    enable-hot-corners = false;
  };

  "org/gnome/settings-daemon/plugins/media-keys" = {
    help = [];
  };

  "org/gnome/shell" = {
    disabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
    enabled-extensions = ["clipboard-history@alexsaveau.dev" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "space-bar@luchrioh"];
    favorite-apps = ["Alacritty.desktop" "firefox.desktop" "obsidian.desktop" "org.gnome.Nautilus.desktop"];
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

  "org/gnome/shell/keybindings" = {
    screenshot = ["<Shift><Control><Alt>s"];
    screenshot-window = ["<Shift><Control><Super>s"];
    show-screenshot-ui = ["<Super>bracketleft"];
  };
}
