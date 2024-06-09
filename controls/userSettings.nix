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
    desktopEnvironment = lib.mkOption {
      type = lib.types.string;
      default = "gnome";
    };
  };
}
