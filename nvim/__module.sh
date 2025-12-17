#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
dst="$HOME/.config/nvim"
nvim_dir="$current_dir"

log() {
  now=$(date +"%H:%M:%S")
  echo "[nvim | $now]" "$@"
}

needs-install() {
  if test -L "$dst"; then
    log "$dst links to: $(readlink "$dst")"
    log "skipping..."

    return 1
  fi

  if test -d "$dst"; then
    log "$dst exists and is a directory"

    return 1
  fi

  return 0
}

if needs-install; then
  log "creating symlink..."
  log "$dst -> $nvim_dir"

  ln -s "$nvim_dir" "$dst"
fi
