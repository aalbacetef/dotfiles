#!/usr/bin/env bash
set -euo pipefail

script_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

mk-template() {
  local dst_file="$1"

  echo "bash source: ${BASH_SOURCE[0]}"
  echo "script dir: $script_dir"
  echo "writing to: $dst_file"

  if test -z "$dst_file"; then
    echo "please set DST_FILE"
    return 1
  fi

  if test -f "$dst_file"; then
    echo "already exists"
    return 1
  fi

  cp "$script_dir/flake.tpl.nix" "$dst_file"
}

mk-template "$1"
