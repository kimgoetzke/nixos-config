{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./blade.nix
    ./nzxt.nix
  ];
}
