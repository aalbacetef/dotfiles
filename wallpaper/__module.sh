#!/usr/bin/env bash

log() {
  now=$(date +"%H:%M:%S")
  echo "[wallpaper | $now]" "$@"
}

sync-directory() {
  local current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  local src_dir="$current_dir/wallpaper"
  local target_dir="$HOME/.config/wallpaper"
  local parent_dir="$(dirname "$target_dir")"

  log "checking parent directory ($parent_dir) exists..."

  if ! test -d "$parent_dir"; then
    log "directory doesn't exist, creating..."
    mkdir -p "$parent_dir"
  fi

  log "ensuring symlink exists: $src_dir => $target_dir..."

  if test -h "$target_dir"; then
    log "symlink already exists"
    log "done"
    return 0
  fi

  if test -d "$target_dir"; then
    log "error: $target_dir already exists as a folder"
    return 1
  fi

  ln -s "$src_dir" "$target_dir"

  log "done"
}

sync-directory
