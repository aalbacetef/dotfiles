#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cfg_dir_path="$(realpath ~/.tmux)"
cfg_file_path="$(realpath ~/.tmux.conf)"

log() {
  now=$(date +"%H:%M:%S")
  echo "[tmux | $now]" "$@"
}

check_cfg_file_exists() {
  log "checking if ~/.tmux.conf exists..."

  if test -e "$cfg_file_path"; then
    log "config file exists"
    return 0
  fi

  log "not found"
  return 1
}

check_cfg_dir_exists() {
  log "checking if ~/.tmux/ exists..."

  if test -d "$cfg_dir_path"; then
    log "config dir exists"
    return 0
  fi

  log "not found"
  return 1
}

if ! check_cfg_file_exists; then
  log "linking..."
  ln -s "$current_dir/tmux.conf" "$cfg_file_path"
fi

if ! check_cfg_dir_exists; then
  log "linking..."
  ln -s "$current_dir/config" "$cfg_dir_path"
fi
