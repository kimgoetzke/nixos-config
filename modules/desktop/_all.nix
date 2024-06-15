{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];
}
