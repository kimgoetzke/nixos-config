{
  config,
  lib,
  ...
}: {
  config = {
    # IMPORTANT:
    # Create a copy of this file and rename to `user-settings.nix` and fill in your details.
    # If you change the wallpaper, make sure it can be found in the relevant folder.
    userSettings.user = "user";
    userSettings.userName = "First name";
    userSettings.userFullName = "Your full name";
    userSettings.userEmail = "some@email.address";
    userSettings.hostName = "nixos";
    userSettings.baseDirectory = "/home/${config.userSettings.user}/projects/nixos-config";
    userSettings.relativeTargetDirectory = "/Documents/NixOS";
    userSettings.defaultShell = "zsh";
    userSettings.wallpaper = "${config.userSettings.baseDirectory}/assets/images/wallpaper_abstract_nord4x.png";
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
