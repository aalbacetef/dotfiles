#!/usr/bin/env bash

darwin::nix-update() {
  sudo nix-env --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
  sudo launchctl remove org.nixos.nix-daemon
  sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
}

darwin::brew-sync() {
  # don't install work casks on personal laptop
  if ! test "$IS_WORK_LAPTOP" = "1"; then
    brew bundle install --cleanup --file "$(realpath "$DOTFILES/darwin/Brewfile")"
  fi 

  # combine all deps
  darwin_folder="$(realpath "$DOTFILES/darwin")"

  ## create a temporary Brewfile combining base packages and work deps 
  target_brew="$darwin_folder/Brewfile.generated"
  cat "$darwin_folder/Brewfile" > "$target_brew"
  cat "$darwin_folder/Brewfile.work" >> "$target_brew"

  brew bundle install --cleanup --file "$target_brew"

  ## clean up
  rm "$target_brew"
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
