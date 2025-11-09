#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
target_sym="$(realpath ~)/.config/alacritty"

log() {
  now=$(date +"%H:%M:%S")
  echo "[alacritty | $now]" "$@"
}

needs_install() {
  log "checking if symlink exists..."

  if ! test -L "$target_sym"; then
    if test -d "$target_sym"; then
      log "instead of symlink found directory, exiting"
      return 1
    fi

    log "symlink not found, creating..."
    return 0
  fi

  local pointing_to

  pointing_to="$(realpath "$target_sym")"
  log "found symlink, pointing to: $pointing_to"

  if test "$pointing_to" = "$current_dir"; then
    log "nothing to do"
    return 1
  fi

}

install() {
  log "ln -s \"$current_dir\" >> \"$target_sym\""
  ln -s "$current_dir" "$target_sym"
}

if needs_install; then
  install
fi
