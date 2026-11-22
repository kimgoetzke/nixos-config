{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  # TODO: Home Manager removed wayprompt, try removing it soon
  stylix.targets.wayprompt.enable = false;

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
    ./neovim.nix
    ./obsidian.nix
    ./zed.nix
    ./mpv.nix
  ];
}
