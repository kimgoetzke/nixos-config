{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  home.username = "kgoe";
  home.homeDirectory = "/home/kgoe";
  home.stateVersion = "24.05";
  home.packages =
    [
      # Development
      pkgs.jetbrains-toolbox
      # pkgs.jetbrains.idea-ultimate # Copilot doesn't connect but don't want to overwrite my synced config
      pkgs.postman
      (pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Iosevka"
          "IosevkaTerm"
        ];
      })

      # Art
      pkgs.aseprite

      # Misc
      pkgs.dconf2nix

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ lib.optionals userSettings.desktopEnvironments.isGnomeEnabled [
      pkgs.gnome.gnome-tweaks
    ];

  nixpkgs = {
    overlays = [
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ./../../modules/applications/_all.nix
  ];

  # Applications
  vscode.enable = true;
  vscode.withExtensions = true;
  firefox.enable = true;
  firefox.withProfile = true;
  alacritty.enable = true;
  git.enable = true;
  java.enable = true;

  # Shell
  bash.enable = userSettings.shells.isBashEnabled;
  zsh.enable = userSettings.shells.isZshEnabled;
  home.shellAliases = {
    ls = "ls --color";
    c = "clear";
    nht = "nh os test ~/projects/nixos-config -H default";
    nhs = "nh os switch ~/projects/nixos-config -H default";
    proper = "cd ~/projects && ls -1";
    idea = "${pkgs.jetbrains.idea-ultimate}/idea-ultimate/bin/idea.sh";
    anw = "alacritty msg create-window";
    ".2" = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kgoe/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  dconf.settings = {
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

    "org/gnome/shell" = {
      disabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
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
  };

  programs.home-manager.enable = true;
}
