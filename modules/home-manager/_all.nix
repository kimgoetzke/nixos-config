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
    ./wezterm.nix
    ./java.nix
    (import ./rust.nix {inherit inputs config pkgs lib userSettings;})
    ./bash.nix
    ./zsh.nix
    ./hyprland/hyprland.nix
    ./direnv.nix
    ./btop.nix
    ./gtk.nix
    ./yazi.nix
  ];
}
