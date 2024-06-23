# -------------------------------------------------------- #
#                      INSTRUCTIONS                        #
# -------------------------------------------------------- #
# 1. Create a copy of this file and rename to 'user.nix'   #
# 2. Fill in your details                                  #
# 3. Move the file to './hosts/{your host}/user.nix'       #
# -------------------------------------------------------- #
{
  config,
  lib,
  ...
}: {
  config = {
    userSettings.user = "your_user";
    userSettings.userName = "First name";
    userSettings.userFullName = "Your full name";
    userSettings.userEmail = "some@email.address";
    userSettings.hostName = "nixos";
    userSettings.baseDirectory = "/home/${config.userSettings.user}/projects/nixos-config"; # Location of this repo
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
}
