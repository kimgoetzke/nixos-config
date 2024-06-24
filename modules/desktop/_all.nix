{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];
}
