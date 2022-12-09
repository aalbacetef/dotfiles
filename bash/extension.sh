#!/usr/bin/env bash

function mkd() {
  local arg="$1"
  local path="$2"
  if [[ "$arg" == "" ]]; then 
    echo "no path specified"
    return 1
  fi 

  if [[ "$path" == "" ]]; then
    path="$1"
  fi

  mkdir "$arg" "$path" && cd "$path"
}
