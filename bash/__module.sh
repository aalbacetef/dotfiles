#!/usr/bin/env bash

RC_FILE="$(realpath ~/.bashrc)"
LINE="source $(realpath ./bash/bashrc)"

log() {
  now=$(date +"%H:%M:%S")
  echo "[bash | $now]" "$@"
}

needs_install() {

  log "checking if bashrc file exists..."

  if test ! -f "$RC_FILE"; then
    log "bashrc file not found"
    return 0
  fi
  log "bashrc file found "

  log "checking if bashrc extensions have been sourced..."
  if grep -q "$LINE" "$RC_FILE"; then
    log "bashrc extensions found, skipping"
    return 1
  fi

  log "bashrc extensions not found, adding"
}

install() {
  log "echo \"$LINE\" >> \"$RC_FILE\""
  echo "$LINE" >>"$RC_FILE"
}

if needs_install; then
  install
fi
