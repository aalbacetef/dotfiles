#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
CONFIG_DIR="$(realpath ~/.config/ranger)"
needs_dir() {
  log "checking if config dir (~/.config/ranger) exists..."

  if test -e "$CONFIG_DIR"; then
    log "config dir exists, exiting"
    return 1
  fi

  log "not found"
  return 0
}

link_ranger() {
  local SRC
  SRC="$(realpath "$current_dir")"

  log "linking: $SRC -> $CONFIG_DIR"
  ln -s "$SRC" "$CONFIG_DIR"
  log "done"
}

if needs_dir; then
  link_ranger
fi

