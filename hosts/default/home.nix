{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  home.username = userSettings.userName;
  home.homeDirectory = "/home/${userSettings.userName}";
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
      pkgs.xclip # Dependency of zsh.nix

      # Art
      pkgs.aseprite

      # Misc
      pkgs.dconf2nix

      # Scripts
      (pkgs.writeShellScriptBin "kim" (builtins.readFile ./../../assets/scripts/kim.sh))
      (pkgs.writeShellScriptBin "file" (builtins.readFile ./../../assets/scripts/file.sh))
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
  wayland.enable = userSettings.desktopEnvironments.isHyprlandEnabled;

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

  dconf.settings =
    if userSettings.desktopEnvironments.isGnomeEnabled
    then (import ./../../assets/configs/gnome/dconf.nix {inherit lib;})
    else {};

  programs.home-manager.enable = true;
}
