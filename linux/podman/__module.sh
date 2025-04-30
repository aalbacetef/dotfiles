#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

src_path="$current_dir/containers"
cfg_path="$(realpath ~/.config/containers)"

log() {
  now=$(date +"%H:%M:%S")
  echo "[podman | $now]" "$@"
}

check_cfg_exists() {
  log "checking if config path ($cfg_path) exists"

  if test -e "$cfg_path"; then
    log "config directory exists"
    return 0
  fi

  log "not found"
  return 1
}

if ! check_cfg_exists; then
  log "linking..."
  ln -s "$src_path" "$cfg_path"
fi
