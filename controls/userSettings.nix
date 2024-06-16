{
  config,
  lib,
  ...
}: {
  config = {
    userSettings.userName = "kgoe";
    userSettings.hostName = "blade";
    userSettings.baseDirectory = "/home/${config.userSettings.userName}/projects/nixos-config";
    userSettings.relativeTargetDirectory = "/Documents/NixOS";
    userSettings.defaultShell = "zsh";
    userSettings.shells = {
      isZshEnabled = true;
      isBashEnabled = false;
    };
    userSettings.desktopEnvironment = "hyprland";
    userSettings.desktopEnvironments = {
      isGnomeEnabled = false;
      isHyprlandEnabled = true;
    };
    userSettings.isDockerEnabled = true;
  };

  options.userSettings = {
    userName = lib.mkOption {
      type = lib.types.string;
      default = "kgoe";
    };
    hostName = lib.mkOption {
      type = lib.types.string;
      default = "nixos";
    };
    baseDirectory = lib.mkOption {
      type = lib.types.string;
      default = "/home/${config.userSettings.userName}/projects/nixos-config";
    };
    relativeTargetDirectory = lib.mkOption {
      type = lib.types.string;
      default = "/Documents/NixOS";
    };
    targetDirectory = lib.mkOption {
      type = lib.types.string;
      default = "/home/${config.userSettings.userName}${config.userSettings.relativeTargetDirectory}";
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
