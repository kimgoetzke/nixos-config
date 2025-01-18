#!/usr/bin/env bash
# shellcheck disable=SC2164

folder() {
  if [[ -z $NIX_USER || ${#NIX_USER} -lt 2 ]]; then
    echo "Error: You must export NIX_USER for this script to work."
    exit 1
  fi

  case "$1" in
  "pro" | "proper")
    echo "/home/$NIX_USER/projects/"
    cd "/home/$NIX_USER/projects/"
    ;;
  "home" | "kim")
    echo "/home/$NIX_USER/"
    cd "/home/$NIX_USER/"
    ;;
  "nix" | "nixr")
    echo "/home/$NIX_USER/projects/nixos-config/"
    cd "/home/$NIX_USER/projects/nixos-config/"
    ;;
  "nixl")
    echo "/home/$NIX_USER/Documents/NixOS/"
    cd "/home/$NIX_USER/Documents/NixOS/"
    ;;
  "rustlings")
    echo "/home/$NIX_USER/projects/rustlings/"
    cd "/home/$NIX_USER/projects/rustlings/"
    ;;
  "rusteroids")
    echo "/home/$NIX_USER/projects/rusteroids"
    cd "/home/$NIX_USER/projects/rusteroids"
    ;;
  "github.io" | "gio")
    echo "/home/$NIX_USER/projects/kimgoetzke.github.io"
    cd "/home/$NIX_USER/projects/kimgoetzke.github.io"
    ;;
  "progen2" | "pg2")
    echo "/home/$NIX_USER/projects/procedural-generation-2"
    cd "/home/$NIX_USER/projects/procedural-generation-2"
    ;;
  "plep" | "practice-leptos")
    echo "/home/$NIX_USER/projects/practice-leptos"
    cd "/home/$NIX_USER/projects/practice-leptos"
    ;;
  "pgo")
    echo "/home/$NIX_USER/projects/practice-go"
    cd "/home/$NIX_USER/projects/practice-go"
    ;;
  *)
    echo "Error: Folder not recognised. Recognised files are: pro/proper, home, nix/nixr, nixl, rusteroids, rustlings, gio/github.io, progen2/pg2, pgo."
    ;;
  esac
}

if [ $# -eq 0 ]; then
  echo "Error: No folder specified. Please provide a folder name."
  exit 1
else
  folder "$1"
fi
