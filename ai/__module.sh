#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
src_file="$current_dir/aider.conf.yml"
dst_file="$(realpath ~)/.aider.conf.yml"

log() {
  now=$(date +"%H:%M:%S")
  echo "[aider | $now]" "$@"
}

needs_install() {
  log "checking if conf file ($dst_file) exists..."

  if test ! -f "$dst_file"; then
    log "conf file not found"
    return 0
  fi
  log "conf file found "

  return 1
}

install() {
  log "linking \"$src_file\" -> \"$dst_file\""
  ln -s "$src_file" "$dst_file"
}

if needs_install; then
  install
fi
