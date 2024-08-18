{
  inputs,
  lib,
  ...
}: {
  user = "your_user";
  userName = "First or nick name"; # Your first name or nick name, set as DESC and used by hyprlock
  userFullName = "Your full name"; # Full name, used by Git
  userEmail = "some@email.address"; # Email address, used by Git
  hostName = "nixos";
  baseDirectory = "/home/your_user/projects/nixos-config"; # Location of this repo, used by env vars and more
  targetDirectory = "/home/your_user/Documents/NixOS"; # Location of some assets, used by scripts, must be in line with the below
  relativeTargetDirectory = "/Documents/NixOS"; # Relative path from home/your_user where some assets are stored e.g. wallpaper
  wallpaperPath = "/home/your_user/projects/nixos-config/assets/images"; # Source path for your wallpaper
  wallpaperFile = "wallpaper_abstract_nord4x_shadow.png"; # Source file name
  defaultShell = "zsh";
  shells.isZshEnabled = true;
  shells.isBashEnabled = false;
  desktopEnvironment = "hyprland";
  desktopEnvironments.isGnomeEnabled = false;
  desktopEnvironments.isHyprlandEnabled = true;
  isDockerEnabled = true;
  modes.isGamingEnabled = false;
  hyprland.primaryMonitor = "eDP-1"; # Your primary monitor when using Hyprland, use port names e.g. DP-1, HDMI-1
  hyprland.leftMonitor = "DP-1"; # Optional, monitor to the left of the default monitor, use port names
}
