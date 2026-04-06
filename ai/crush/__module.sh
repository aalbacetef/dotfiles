#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
dst="$(realpath ~)/.config/crush"

log() {
  now=$(date +"%H:%M:%S")
  echo "[opencode | $now]" "$@"
}

needs_install() {
  log "checking if conf dir ($dst) exists..."

  if test ! -f "$dst"; then
    log "conf file not found"
    return 0
  fi

  log "conf file found "

  return 1
}

install() {
  log "linking \"$current_dir\" -> \"$dst\""
  ln -s "$current_dir" "$dst"
}

if needs_install; then
  install
fi
