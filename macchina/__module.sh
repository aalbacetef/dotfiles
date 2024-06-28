#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
TARGET_PATH=$(realpath -s ~/.config/macchina)

log() {
  now=$(date +"%H:%M:%S")
  echo "[macchina | $now]" "$@"
}

# this will run even if the target config is not a symlink
needs_config_install() {
  log "CONFIG PATH: $TARGET_PATH"
  log "checking if config needs to be symlinked..."

  if test -d "$TARGET_PATH"; then
    log "config already exists, skipping"
    return 1
  fi

  return 0
}

install_config() {
  from="$current_dir"
  to="$TARGET_PATH"

  log "symlink: "
  log "  $from => $to"

  ln -s "$from" "$to"
}

if needs_config_install; then
  install_config
fi
