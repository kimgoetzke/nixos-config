{
  config,
  lib,
  ...
}: {
  options.userSettings = {
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

  config = {
    userSettings.defaultShell = "zsh";
    userSettings.desktopEnvironment = "gnome";
    userSettings.isDockerEnabled = true;
  };
}
