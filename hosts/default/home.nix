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
  hyprland.enable = userSettings.desktopEnvironments.isHyprlandEnabled;

  # Shell
  bash.enable = userSettings.shells.isBashEnabled;
  zsh.enable = userSettings.shells.isZshEnabled;
  home.shellAliases = {
    ls = "ls --color";
    c = "clear";
    nht = "nh os test ~/projects/nixos-config -H default";
    nhb = "nh os boot ~/projects/nixos-config -H default";
    nhs = "nh os switch ~/projects/nixos-config -H default";
    nhc = "nh clean all --keep 3";
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

  # Move files to home directory for future use
  home.file = {
    "${userSettings.relativeTargetDirectory}/wallpaper.png" = {
      source = ./../../assets/images/wallpaper_abstract_nord4x.png;
    };
    "${userSettings.relativeTargetDirectory}/profile.png" = {
      source = ./../../assets/images/randy.png;
    };
  };

  # Session variables
  home.sessionVariables = {
  };

  dconf.settings =
    if userSettings.desktopEnvironments.isGnomeEnabled
    then (import ./../../assets/configs/gnome/dconf.nix {inherit lib;})
    else {};

  programs.home-manager.enable = true;
}
