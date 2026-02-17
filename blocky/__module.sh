#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
from="$current_dir"
to="$HOME/.config/blocky"
files="config.yml"

log() {
  now=$(date +"%H:%M:%S")
  echo "[blocky | $now]" "$@"
}

install-symlink() {
  # ensure $HOME is set
  if test -z "$HOME"; then
    log "\$HOME is not set"
    return 1
  fi

  log "files in $from will have symlinks in $to"
  if ! test -d "$to"; then
    log "config directory not found, creating: $to"
    mkdir "$to"
  fi

  for f in $files; do
    src="$to/$f"
    target="$from/$f"

    if test -f "$src"; then
      log "file already exists, skipping"
    else
      echo "$src => $target"
      ln -s "$target" "$src"
    fi
  done
}

install-service() {
  local service='blocky.service'

  log "installing service"

  systemctl --user is-enabled --quiet $service || {
    log "service not enabled, enabling..."
    systemctl --user enable --now $service
    log "done"

    return 0
  }

  log "service already installed, skipping..."
}

install-symlink
install-service
