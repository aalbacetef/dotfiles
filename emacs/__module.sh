#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

log() {
  now=$(date +"%H:%M:%S")
  echo "[emacs | $now]" "$@"
}


CONFIG_DIR="$(realpath ~/.config/spacemacs)"
CONFIG_FILE="$(realpath ~/.emacs.el)"

needs_spacemacs() {
  log "checking if config dir (~/.config/spacemacs) exists..."

  if test -e "$CONFIG_DIR"; then
    log "config dir exists, exiting"
    return 1
  fi

  log "not found"
  return 0
}

link_spacemacs() {
  local SRC
  SRC="$(realpath "$current_dir/spacemacs")"

  log "linking: $SRC -> $CONFIG_DIR"
  ln -s "$SRC" "$CONFIG_DIR"
  log "done"
}

needs_init_file() {
  log "checking if config file (~/.emacs.el) exists..."

  if test -e "$CONFIG_FILE" ; then 
    log "config file exists, exiting"
    return 1
  fi

  log "not found"
  return 0
}

link_init_file() {
  local SRC
  SRC="$(realpath "$current_dir/emacs.el")"

  log "linking: $SRC -> $CONFIG_FILE"
  ln -s "$SRC" "$CONFIG_FILE"
  log "done"
}

if needs_spacemacs; then
  link_spacemacs
fi

if needs_init_file; then 
  link_init_file
fi
