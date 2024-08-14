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

  "org/gnome/desktop/wm/keybindings" = {
    close = ["<Shift><Super>q"];
    switch-to-workspace-1 = ["<Super>1"];
    switch-to-workspace-2 = ["<Super>2"];
    switch-to-workspace-3 = ["<Super>3"];
    switch-to-workspace-last = [];
    toggle-fullscreen = ["<Super>F11"];
    maximize = [];
    unmaximize = [];
  };

  "org/gnome/nautilus/icon-view" = {
    default-zoom-level = "small";
  };

  "org/gnome/nautilus/preferences" = {
    default-folder-viewer = "icon-view";
    migrated-gtk-settings = true;
    search-filter-time-type = "last_modified";
  };

  "org/gnome/desktop/interface" = {
    enable-hot-corners = false;
  };

  "org/gnome/mutter" = {
    edge-tiling = false;
  };

  "org/gnome/mutter/keybindings" = {
    toggle-tiled-left = [];
    toggle-tiled-right = [];
  };

  "org/gnome/settings-daemon/plugins/media-keys" = {
    custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"];
    help = [];
    home = ["<Super>m"];
    www = ["<Super>f"];
  };

  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    binding = "<Super>t";
    command = "alacritty";
    name = "Alacritty";
  };

  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
    binding = "<Super>j";
    command = "jetbrains-toolbox";
    name = "Jetbrains Toolbox";
  };

  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
    binding = "<Super>o";
    command = "obsidian";
    name = "Obsidian";
  };

  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
    binding = "<Super>a";
    command = "aseprite";
    name = "Aseprite";
  };

  "org/gnome/shell" = {
    disabled-extensions = ["screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
    enabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "clipboard-history@alexsaveau.dev" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "space-bar@luchrioh" "pop-shell@system76.com"];
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

  "org/gnome/shell/extensions/pop-shell" = {
    active-hint = true;
    active-hint-border-radius = lib.hm.gvariant.mkUint32 4;
    gap-inner = lib.hm.gvariant.mkUint32 7;
    gap-outer = lib.hm.gvariant.mkUint32 7;
    mouse-cursor-focus-location = lib.hm.gvariant.mkUint32 4;
    mouse-cursor-follows-active-window = true;
    show-title = true;
    smart-gaps = false;
    snap-to-grid = false;
    tile-by-default = true;
  };

  "org/gnome/shell/keybindings" = {
    screenshot = ["<Super><Control><Alt>s"];
    screenshot-window = ["<Super><Control><Super>s"];
    show-screenshot-ui = ["<c>bracketleft"];
  };
}
