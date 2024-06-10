#!/usr/bin/env bash

file() {
    case "$1" in
        "fi")
          code '/home/kgoe/projects/nixos-config/assets/scripts/fi.sh'
              ;;
        "ssh")
            code '/home/kgoe/.ssh/config'
            ;;
        *)
            echo "Error: File not recognised. Recognised files are: fi, ssh."
            ;;
    esac
}
file "$1"