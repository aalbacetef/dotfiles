#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
src_dir="$current_dir/overrides"
target_sym="$(realpath ~)/.local/share/flatpak/overrides"

log() {
  now=$(date +"%H:%M:%S")
  echo "[flatpak | $now]" "$@"
}

needs_install() {
  log "checking if symlink exists..."

  if ! test -L "$target_sym"; then
    if test -d "$target_sym"; then
      log "instead of symlink found directory"

      if test "$IGNORE_FLATPAK_OVERRIDES" = "on"; then
        log "IGNORE_FLATPAK_OVERRIDES is set to 'on', skipping"
        return 1
      fi

      log "backing up: mv $target_sym $target_sym.backup"
      mv "$target_sym" "$target_sym.backup"
      return 0
    fi

    log "symlink not found, creating..."
    return 0
  fi

  local pointing_to

  pointing_to="$(realpath "$target_sym")"
  log "found symlink, pointing to: $pointing_to"

  if test "$pointing_to" = "$src_dir"; then
    log "nothing to do"
    return 1
  fi

}

install() {
  log "ln -s \"$src_dir\" >> \"$target_sym\""
  ln -s "$src_dir" "$target_sym"
}

if needs_install; then
  install
fi

log "adding all flatpak apps..."
"$current_dir/install-apps.fish"
log "done"
