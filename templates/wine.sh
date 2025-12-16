#!/usr/bin/env bash

###############################################
#
# Helper for installing games with wine.
#
###############################################
wine-install() {
  local current_dir
  local pfx
  local exe_bin
  local game

  exe_bin="$(realpath "$1")"
  current_dir="$(realpath "$(pwd)")"
  game="$current_dir/game"
  pfx="$current_dir/pfx"

  wine-pfx-setup

  ({
    export WINEPREFIX="$pfx"

    cd "$(dirname "$exe_bin")"

    base_name="$(basename "$exe_bin")"
    echo "running: $base_name"
    wine "$(basename "$exe_bin")"
  })
}

###############################################
#
# Helper for setting up a pfx when installing
# games with wine.
#
###############################################
wine-pfx-setup() {
  local current_dir
  local pfx
  local game

  current_dir="$(realpath "$(pwd)")"
  game="$current_dir/game"
  pfx="$current_dir/pfx"

  export WINEPREFIX="$pfx"
  winecfg /v win7

  mkdir -p "$pfx"
  mkdir -p "$game"

  cat <<EOF >"$current_dir/files.reg"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders]
"Desktop"="Z:{{ .GAME }}/game/Desktop"
"Personal"="Z:{{ .GAME }}/game/Documents"
"My Pictures"="Z:{{ .GAME }}/game/Pictures"
"My Music"="Z:{{ .GAME }}/game/Music"
"My Video"="Z:{{ .GAME }}/game/Videos"
"My Templates"="Z:{{ .GAME }}/game/Templates"
"{7D83EE9B-3736-4BAB-956B-4D1DC0E1F7CC}"="Z:{{ .GAME }}/game/Downloads"

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders]
"Desktop"="%USERPROFILE%/Desktop"
"Personal"="%USERPROFILE%/Documents"
"My Pictures"="%USERPROFILE%/Pictures"
"My Music"="%USERPROFILE%/Music"
"My Video"="%USERPROFILE%/Videos"
"{7D83EE9B-3736-4BAB-956B-4D1DC0E1F7CC}"="%USERPROFILE%/Downloads"
EOF

  sed -i "s@"'{{ .GAME }}'"@$current_dir@gm" "$current_dir/files.reg"
  sed -i 's@/@\\\\@gm' "$current_dir/files.reg"

  local targets="Desktop Documents Pictures Music Videos Downloads Templates"

  local src_dir="$pfx/drive_c/users/arturo"
  local target_dir="$current_dir/game"

  for d in $targets; do
    if test -L "$src_dir/$d"; then
      rm "$src_dir/$d"
    fi

    if test -d "$src_dir/$d"; then
      rm -rf "$src_dir/$d"
    fi

    mkdir -p "$target_dir/$d"
    ln -s "$target_dir/$d" "$src_dir/$d"
  done

  wine regedit "$current_dir/files.reg"
  rm "$current_dir/files.reg"
}
