#!/usr/bin/env bash


function mkd() {
  local path="$1"

  mkdir -p "$path" && cd "$path"
}
