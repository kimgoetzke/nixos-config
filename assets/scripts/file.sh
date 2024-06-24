#!/usr/bin/env bash

file() {
  if [[ -z $NIX_USER || ${#NIX_USER} -lt 2 ]]; then
    echo "Error: You must export NIX_USER for this script to work."
    exit 1
  fi

  case "$1" in
  "this" | "fi")
    code "/home/$NIX_USER/projects/nixos-config/assets/scripts/file.sh"
    ;;
  "ssh")
    code "/home/$NIX_USER/.ssh/config"
    ;;
  *)
    echo "Error: File not recognised. Recognised files are: this/fi, ssh."
    ;;
  esac
}
file "$1"
