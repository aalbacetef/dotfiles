#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

cfg_path="$(realpath ~/.config/helix)"

log() {
  now=$(date +"%H:%M:%S")
  echo "[helix | $now]" "$@"
}

check_cfg_exists() {
  log "checking if ~/.config/helix exists"

  if test -e "$cfg_path"; then
    log "config directory exists"
    return 0
  fi

  log "not found"
  return 1
}

if ! check_cfg_exists; then
  log "linking..."
  ln -s "$current_dir" "$cfg_path"
fi
