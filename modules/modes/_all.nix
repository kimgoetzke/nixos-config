{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./gaming.nix
  ];
}
