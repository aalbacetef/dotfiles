#!/usr/bin/env bash

function mkd() {
  local arg="$1"
  local path="$2"

  if [[ "$path" == "" ]]; then
    path="$1"
  fi

  mkdir "$arg" "$path" && cd "$path"
}
