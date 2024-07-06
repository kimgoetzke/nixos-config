{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  home.username = userSettings.user;
  home.homeDirectory = "/home/${userSettings.user}";
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
      (pkgs.writeShellScriptBin "fo" (builtins.readFile ./../../assets/scripts/fo.sh))
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
    (import ./../../modules/applications/_all.nix {inherit config pkgs lib inputs userSettings;})
  ];

  # Applications
  vscode.enable = true;
  vscode.withExtensions = true;
  firefox.enable = true;
  firefox.withProfile = true;
  alacritty.enable = true;
  git.enable = true;
  java.enable = false;
  hyprland.enable = userSettings.desktopEnvironments.isHyprlandEnabled;
  programs.home-manager.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
    };
  };

  # Shell
  bash.enable = userSettings.shells.isBashEnabled;
  zsh.enable = userSettings.shells.isZshEnabled;
  home.shellAliases = {
    ls = "ls --color";
    c = "clear";
    nht = "nh os test ${userSettings.baseDirectory} -H default";
    nhb = "nh os boot ${userSettings.baseDirectory} -H default";
    nhs = "nh os switch ${userSettings.baseDirectory} -H default";
    nhc = "nh clean all --keep 3";
    nhca = "nh clean all --keep 1";
    nfu = "nix flake update";
    nixs = "nixos-rebuild switch --flake ${userSettings.baseDirectory}#default";
    nixuser = "cd ${userSettings.baseDirectory}/users && git rm --cached user.nix && git add --intent-to-add user.nix && git update-index --assume-unchanged user.nix";
    # TODO: Figure out a way to set a better label for a generation (none of the below work)
    #nhs = "export NIXOS_LABEL=\"NixOS - $(date +%Y-%m-%d) $(date +%R)\" && nh os switch ~/projects/nixos-config -H default";
    #nhsl = "NIXOS_LABEL=\"$(date +%Y-%m-%d) $(date +%R)\" nh os switch ~/projects/nixos-config -H default";
    #nixsl = "NIXOS_LABEL=\"NixOS - $(date +%Y-%m-%d) $(date +%R)\" nixos-rebuild switch --flake ${userSettings.baseDirectory}#default";
    proper = "cd ~/projects && ls -1";
    anw = "alacritty msg create-window";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "rustshell" = "nix-shell ${userSettings.baseDirectory}/shells/rust.nix";
    "dotnetshell" = "nix-shell ${userSettings.baseDirectory}/shells/dotnet.nix";
  };

  # Move all relevant assets to home directory for use anywhere
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
    "NIX_FOLDER" = "${userSettings.targetDirectory}";
    "NIX_PROJECT_FOLDER" = "${userSettings.baseDirectory}";
    "NIX_USER" = "${userSettings.user}";
  };

  # Gnome dconf settings
  dconf.settings =
    if userSettings.desktopEnvironments.isGnomeEnabled
    then (import ./../../assets/configs/gnome/dconf.nix {inherit lib;})
    else {};
}
