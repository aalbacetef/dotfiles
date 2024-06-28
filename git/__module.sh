#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

log() {
  now=$(date +"%H:%M:%S")
  echo "[git | $now]" "$@"
}

log "running $current_dir/gitconfig.sh..."

"$current_dir/gitconfig.sh"

log "done"
