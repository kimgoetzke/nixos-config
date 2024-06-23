{
  config,
  lib,
  ...
}: {
  options.userSettings = {
    user = lib.mkOption {
      type = lib.types.string;
    };
    userName = lib.mkOption {
      type = lib.types.string;
    };
    userFullName = lib.mkOption {
      type = lib.types.string;
    };
    userEmail = lib.mkOption {
      type = lib.types.string;
    };
    hostName = lib.mkOption {
      type = lib.types.string;
      default = "nixos";
    };
    baseDirectory = lib.mkOption {
      type = lib.types.string;
      default = "/home/${config.userSettings.user}/projects/nixos-config";
    };
    relativeTargetDirectory = lib.mkOption {
      type = lib.types.string;
      default = "/Documents/NixOS";
    };
    targetDirectory = lib.mkOption {
      type = lib.types.string;
      default = "/home/${config.userSettings.user}${config.userSettings.relativeTargetDirectory}";
    };
    wallpaper = lib.mkOption {
      type = lib.types.string;
    };
    defaultShell = lib.mkOption {
      type = lib.types.string;
      default = "zsh";
    };
    shells = {
      isZshEnabled = lib.mkOption {
        type = lib.types.bool;
        default = config.userSettings.defaultShell == "zsh";
      };
      isBashEnabled = lib.mkOption {
        type = lib.types.bool;
        default = config.userSettings.defaultShell == "bash";
      };
    };
    desktopEnvironment = lib.mkOption {
      type = lib.types.string;
      default = "gnome";
    };
    desktopEnvironments = {
      isGnomeEnabled = lib.mkOption {
        type = lib.types.bool;
        default = config.userSettings.desktopEnvironment == "gnome";
      };
      isHyprlandEnabled = lib.mkOption {
        type = lib.types.bool;
        default = config.userSettings.desktopEnvironment == "hyprland";
      };
    };
    isDockerEnabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
}
