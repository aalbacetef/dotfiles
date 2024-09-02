#!/usr/bin/env bash

darwin::nix-update() {
  sudo nix-env --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
  sudo launchctl remove org.nixos.nix-daemon
  sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
}

darwin::brew-sync() {
  brew bundle install --cleanup --file "$(realpath "$DOTFILES/darwin/Brewfile")"
}

darwin::ds-cleanup() {
  find "$HOME" -name '.DS_Store' -type f -delete -print  2> /dev/null
}

darwin::help() {
  echo ""
  echo "commands available"
  echo "  - darwin::brew-sync"
  echo "  - darwin::ds-cleanup"
  echo "  - darwin::nix-update"
  echo ""
}
