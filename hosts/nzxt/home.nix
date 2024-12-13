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
      pkgs.xclip # Dependency of zsh.nix

      # Art
      pkgs.aseprite

      # Misc
      pkgs.dconf2nix

      # Scripts
      (pkgs.writeShellScriptBin "kim" (builtins.readFile ./../../assets/scripts/kim.sh))
      (pkgs.writeShellScriptBin "file" (builtins.readFile ./../../assets/scripts/file.sh))
      (pkgs.writeShellScriptBin "folder" (builtins.readFile ./../../assets/scripts/folder.sh))
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
  btop.enable = true;
  direnv.enable = true;
  yazi.enable = true;
  programs.home-manager.enable = true;
  programs.mpv.enable = true;
  programs.obs-studio.enable = true;

  # Shell
  bash.enable = userSettings.shells.isBashEnabled;
  zsh.enable = userSettings.shells.isZshEnabled;
  home.shellAliases = {
    ls = "ls --color";
    c = "clear";
    fi = "file";
    nht = "nh os test ${userSettings.baseDirectory} -H default";
    nhb = "nh os boot ${userSettings.baseDirectory} -H default";
    nhs = "nh os switch ${userSettings.baseDirectory} -H default";
    nhc = "nh clean all --keep 3";
    nhca = "nh clean all --keep 1";
    nfu = "nix flake update --flake ${userSettings.baseDirectory}";
    nsr = "sudo nix-store --verify --check-contents --repair";
    nixs = "nixos-rebuild switch --flake ${userSettings.baseDirectory}#default";
    nixuser = "cd ${userSettings.baseDirectory}/users && git rm --cached user.nix && git add --intent-to-add user.nix && git update-index --assume-unchanged user.nix";
    proper = "cd ~/projects && ls -1";
    anw = "alacritty msg create-window";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "jb" = "nohup jetbrains-toolbox &";
    "rustrover" = "nohup /home/${userSettings.user}/.local/share/JetBrains/Toolbox/apps/rustrover/bin/rustrover.sh . &";
    "idea" = "nohup /home/${userSettings.user}/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh . &";
    "rider" = "nohup /home/${userSettings.user}/.local/share/JetBrains/Toolbox/apps/rider/bin/rider.sh . &";
    "webstorm" = "nohup /home/${userSettings.user}/.local/share/JetBrains/Toolbox/apps/webstorm/bin/webstorm.sh . &";
  };

  # Move all relevant assets to home directory for use anywhere
  home.file = {
    "${userSettings.relativeTargetDirectory}/wallpaper.png" = {
      source = ./../../assets/images/${userSettings.wallpaperFile};
    };
    "${userSettings.relativeTargetDirectory}/profile.png" = {
      source = ./../../assets/images/${userSettings.profileFile};
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
