{
  config,
  lib,
  ...
}: {
  user = "your_user";
  userName = "First or nick name"; # Your first name or nick name, set as DESC and used by hyprlock
  userFullName = "Your full name"; # Full name, used for Git
  userEmail = "some@email.address"; # Email address, used for Git
  hostName = "nixos";
  baseDirectory = "/home/your_user/projects/nixos-config"; # Location of this repo, used by env vars and more
  relativeTargetDirectory = "/Documents/NixOS"; # Relative path from home/your_user where some assets are stored e.g. wallpaper
  wallpaper = "/home/your_user/projects/nixos-config/assets/images/wallpaper_abstract_nord4x.png"; # Source file for your wallpaper
  defaultShell = "zsh";
  shells.isZshEnabled = true;
  shells.isBashEnabled = false;
  desktopEnvironment = "hyprland";
  desktopEnvironments.isGnomeEnabled = false;
  desktopEnvironments.isHyprlandEnabled = true;
  isDockerEnabled = true;
}
