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
  "dl" | "downloads")
    echo "/home/$NIX_USER/Downloads/"
    cd "/home/$NIX_USER/Downloads/"
    ;;
  "nix")
    echo "/home/$NIX_USER/projects/nixos-config/"
    cd "/home/$NIX_USER/projects/nixos-config/"
    ;;
  "nixdocs" | "nixbase")
    echo "/home/$NIX_USER/Documents/NixOS/"
    cd "/home/$NIX_USER/Documents/NixOS/"
    ;;
  "listem" )
    echo "/home/$NIX_USER/projects/listem"
    cd "/home/$NIX_USER/projects/listem"
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
  "progen1fe" | "pg1fe")
    echo "/home/$NIX_USER/projects/procedural-generation-1-front-end"
    cd "/home/$NIX_USER/projects/procedural-generation-1-front-end"
    ;;
  "progen1" | "pg1")
    echo "/home/$NIX_USER/projects/procedural-generation-1"
    cd "/home/$NIX_USER/projects/procedural-generation-1"
    ;;
  "progen2" | "pg2")
    echo "/home/$NIX_USER/projects/procedural-generation-2"
    cd "/home/$NIX_USER/projects/procedural-generation-2"
    ;;
  "plep" | "practice-leptos")
    echo "/home/$NIX_USER/projects/practice-leptos"
    cd "/home/$NIX_USER/projects/practice-leptos"
    ;;
  "pgoa" | "pgjwt")
    echo "/home/$NIX_USER/projects/practice-go-jwt-auth"
    cd "/home/$NIX_USER/projects/practice-go-jwt-auth"
    ;;
  "ptau")
    echo "/home/$NIX_USER/projects/practice-tauri-leptos"
    cd "/home/$NIX_USER/projects/practice-tauri-leptos"
    ;;
  *)
    echo "Recognised folders are [General:] home/kim, pro/proper, nix, downloads/dl, nixdocs/nixbase, [Java:] pg1, [Rust:] rustlings, rusteroids, pg2, plep/practice-leptos, ptau, [Go:] pgoa/pgjwt, [C#:] listem, [TypeScript/HTML:] gio/github.io, pg1fe"
    ;;
  esac
}

if [ $# -eq 0 ]; then
  echo "Error: No folder specified. Please provide a folder name."
  exit 1
else
  folder "$1"
fi
