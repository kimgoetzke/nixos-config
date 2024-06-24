#!/usr/bin/env bash
# shellcheck disable=SC2164

fo() {
  if [[ -z $NIX_USER || ${#NIX_USER} -lt 2 ]]; then
    echo "Error: You must export NIX_USER for this script to work."
    exit 1
  fi

  case "$1" in
  "pro")
    cd "/home/$NIX_USER/projects/"
    ;;
  "home" | "kim")
    cd "/home/$NIX_USER/"
    ;;
  "nix" | "nixr")
    cd "/home/$NIX_USER/projects/nixos-config/"
    ;;
  "nixl")
    cd "/home/$NIX_USER/Documents/NixOS/"
    ;;
  *)
    echo "Error: Folder not recognised. Recognised files are: pro, home, nix/nixr, nixl."
    ;;
  esac
}

fo "$1"
