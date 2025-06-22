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
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    (import ./../../modules/home-manager/_all.nix {inherit config pkgs lib inputs userSettings;})
  ];

  # Applications
  vscode.enable = true;
  vscode.withExtensions = true;
  firefox.enable = true;
  firefox.withProfile = true;
  firefox.withTextfox = false;
  alacritty.enable = userSettings.emulator == "alacritty";
  wezterm.enable = userSettings.emulator == "wezterm";
  git.enable = true;
  java.enable = false;
  rust.enable = false;
  hyprland.enable = userSettings.desktopEnvironments.isHyprlandEnabled;
  btop.enable = true;
  direnv.enable = true;
  yazi.enable = true;
  nvim.enable = userSettings.vimDistribution == "neovim";
  programs.home-manager.enable = true;
  programs.mpv.enable = true;
  programs.obs-studio.enable = false;

  # Settings
  gtk-settings.enable = true;

  # Shell
  bash.enable = userSettings.shells.isBashEnabled;
  zsh.enable = userSettings.shells.isZshEnabled;
  home.shellAliases = {
    c = "clear";
    fi = "file";
    nht = "nh os test ${userSettings.baseDirectory} -H default";
    nhb = "nh os boot ${userSettings.baseDirectory} -H default";
    nhs = "nh os switch ${userSettings.baseDirectory} -H default";
    nhc = "nh clean all --keep 2";
    nhca = "nh clean all --keep 1";
    nfu = "nix flake update --flake ${userSettings.baseDirectory}";
    nsr = "sudo nix-store --verify --check-contents --repair";
    nixs = "nixos-rebuild switch --flake ${userSettings.baseDirectory}#default";
    ignorenixuser = "cd ${userSettings.baseDirectory}/users && git add --intent-to-add user.nix && git update-index --assume-unchanged user.nix && cd -";
    undoignorenixuser = "cd ${userSettings.baseDirectory}/users && git rm --cached user.nix && cd -";
    unignorenixuser = "cd ${userSettings.baseDirectory}/users && git rm --cached user.nix && cd -";
    proper = "cd ~/projects && ls -1";
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
    "${userSettings.relativeTargetDirectory}/thumbnail.png" = {
      source = ./../../assets/images/${userSettings.thumbnailFile};
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
