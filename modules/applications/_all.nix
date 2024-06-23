{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./firefox.nix
    ./vscode.nix
    (import ./git.nix {inherit config pkgs lib userSettings;})
    ./alacritty.nix
    ./java.nix
    ./bash.nix
    ./zsh.nix
    ./hyprland/hyprland.nix
  ];
}
