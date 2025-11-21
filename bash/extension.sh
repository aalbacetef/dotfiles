#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

source "$current_dir"/helpers/platform.sh
source "$current_dir"/helpers/doctl.sh

function mkd() {
  local path="$1"

  mkdir -p "$path"
  cd "$path" || echo "could not cd to '$path'"
}

function personal-ssh-ip() {
  local my_ip
  my_ip="$(curl -s api.ipify.org)"

  local firewall_id
  local firewall_name="personal-ssh"
  local rules_to_delete
  local rule_to_add="protocol:tcp,ports:22,address:$my_ip"

  firewall_id=$(doctl::get_firewall_id "$firewall_name")
  if [[ "$firewall_id" == "" ]]; then
    echo "No firewall found"
    return 1
  fi

  echo "found firewall with id: $firewall_id"

  rules_to_delete=$(doctl::get_rules "$firewall_id")
  if [[ "$rules_to_delete" != "" ]]; then
    echo "removing previous inbound rule: $rules_to_delete"
    doctl::remove_rules "$firewall_id" "$rules_to_delete"
  fi

  echo "adding inbound rule: $rule_to_add"
  doctl::add_rule "$firewall_id" "$rule_to_add"
}

function remove-personal-ssh-ip() {
  local firewall_id
  local rules_to_delete

  firewall_id=$(doctl::get_firewall_id "personal-ssh")
  if test -z "$firewall_id"; then
    echo "No firewall found"
    return 1
  fi

  echo "found firewall with id: $firewall_id"

  rules_to_delete=$(doctl::get_rules "$firewall_id")
  if test -z "$rules_to_delete"; then
    echo "no rules to remove"
    return 0
  fi

  echo "removing previous inbound rule: $rules_to_delete"
  doctl::remove_rules "$firewall_id" "$rules_to_delete"
}

## DDO launcher. Added this because steam was struggling to launch DDO.
ddo-launch() {
  # should only run on linux
  if platform::is_linux; then
    echo "only on linux"
    return 1
  fi

  local pfx
  local rootdir

  pfx=$(realpath ~/.steam/debian-installation/steamapps/compatdata/206480/pfx)
  rootdir="$(realpath ~/.steam/debian-installation/steamapps/common/Dungeons\ and\ Dragons\ Online)"

  echo "prefix: $pfx"
  echo "rootdir: $rootdir"
  echo ""
  env WINEPREFIX="$pfx" wine "$rootdir/DNDLauncher.exe"
}

########################################################
#
# Logs out from gcloud services and deletes the
# associated container config (~/.docker/config.json)
#
########################################################
cloud-logout() {
  echo "[cloud-logout] logging out of gcloud..."
  gcloud auth revoke --all
  echo "[cloud-logout] ...done"

  echo "[cloud-logout] rm container config..."
  rm -f ~/.docker/config.json
  echo "[cloud-logout] ...done"
}

##############################
#
# Runs a nix profile upgrade
#
##############################
nix-up() {
  local profile_name="nix"
  local flags="--impure"

  echo "[nix-up] starting nix profile upgrade..."
  echo "[nix-up]   - name: $profile_name"
  echo "[nix-up]   - flags: $flags"

  nix profile upgrade "$profile_name" $flags

  echo "[nix-up] ...done"
}

#######################################
#
# Will watch the current directory
# and run the command passed in
#
# Example:
#   watch-n-run go run ./cmd/server/
#
#######################################
watch-n-run() {
  "$DOTFILES/scripts/watch-n-run.fish" "$@"
}

###########################################
#
# Will lookup the package info and output
# it in JSON format.
#
###########################################
np-info() {
  local pkgname="$1"
  local additional="$2"

  if test -z "$pkgname"; then
    echo "package must be specified"
    return 1
  fi

  if test "$additional" = "--short"; then
    nix-env -qa --description "$pkgname" 2>/dev/null | fold -w 80
    return 0
  fi

  if test "$additional" = "--less"; then
    nix-env -qa --meta --json "$pkgname" 2>/dev/null | jq -C | less -r
    return 0
  fi

  nix-env -qa --meta --json "$pkgname" 2>/dev/null | jq -C
}

##############################
#
# Installs a binary locally
#
##############################
local-install() {
  local path_to_file="$1"

  if test -z "$path_to_file"; then
    echo "no file specified"
    return 1
  fi

  if test -z "$LOCAL_USER_BIN"; then
    echo "no \$LOCAL_USER_BIN env var specified"
    return 1
  fi

  if ! test -d "$LOCAL_USER_BIN"; then
    echo "$LOCAL_USER_BIN is not a directory"
    return 1
  fi

  cp "$path_to_file" "$LOCAL_USER_BIN"
}

#################################
#
# Gets a folder ID based on name
#
#################################
bwf() {
  local name="$1"
  local found

  if test -z "$name"; then
    echo "no name provided"
    return 1
  fi

  found="$(bw list folders | jq -r ".[]|select(.name == \"$name\").id")"

  if test -z "$found"; then
    echo "not found"
    return 1
  fi

  echo "$found"
}

###################################
#
# Returns the names of bw folders
#
###################################
bw-folders() {
  bw list folders | jq -r '.[].name'
}

########################################################
#
# Add an attachment in the developer environment folder
#
########################################################
bw-add-env() {
  local name="$1"
  local filename="$2"

  if test -z "$name"; then
    echo "name is empty. Usage: bw-mk-env NAME FILENAME"
    return 1
  fi

  if test -z "$filename"; then
    echo "filename is empty. Usage: bw-mk-env NAME FILENAME"
    return 1
  fi

  local folderid
  folderid="$(bw list folders | jq -r '.[]|select(.name == "developer environment").id')"

  local itemid
  itemid=$(bwi "$name" "developer environment")

  if test -z "$itemid"; then
    itemid=$(bw-mk-note "$name" "developer environment")
  fi

  if ! test -z "$(bw get attachment "$filename" --itemid="$itemid" --raw)"; then
    echo "attachment already exists"
    return 1
  fi

  bw create attachment --file "$filename" --itemid "$itemid" | jq
}

bwi() {
  local name="$1"
  local folder="$2"

  if test -z "$name"; then
    echo "name is empty"
    return 1
  fi

  if test -z "$folder"; then
    echo "folder is empty"
    return 1
  fi

  local folderid
  local itemid

  folderid="$(bwf "$folder")"
  if test -z "$folderid"; then
    return 1
  fi

  itemid="$(bw list items --folderid="$folderid" | jq -r ".[]|select(.name == \"$name\").id")"

  if test -z "$itemid"; then
    return 1
  fi

  echo "$itemid"
}

bw-mk-note() {
  local name="$1"
  local folder="$2"

  if test -z "$name"; then
    echo "name is empty. Usage: bw-mk-note NAME FOLDER"
    return 1
  fi

  if test -z "$folder"; then
    echo "folder is empty. Usage: bw-mk-note NAME FOLDER"
    return 1
  fi

  local folderid

  folderid="$(bwf "$folder")"
  if test -z "$folderid"; then
    echo "folder doesn't exist"
    return 1
  fi

  itemid=$(bw get template item |
    jq '.login.urls = [] | .type = 2' |
    jq '.secureNote.type = 0' |
    jq ".name = \"$name\"" |
    jq ".folderId = \"$folderid\"" |
    bw encode |
    bw create item |
    jq -r '.id')

  echo "$itemid"
}

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

############################
#
# Ask a message via aider
#
############################
ask() {
  if test -z "$1"; then
    echo "please provider a message: ask MESSAGE"
    return 1
  fi

  local conversation_folder="$(realpath ~/.cache/conversation)"
  local input_history_file="$conversation_folder/aider.input.history"
  local chat_history_file="$conversation_folder/aider.chat.history"
  local llm_history_file="$conversation_folder/aider.llm.history"

  if ! test -d "$conversation_folder"; then
    mkdir -p "$conversation_folder"
  fi

  local default_model="${ASK_ME:-gemini/gemini-2.5-flash}"

  aider --no-git \
    --dry-run \
    --model "$default_model" \
    --input-history-file="$input_history_file" \
    --chat-history-file="$chat_history_file" \
    --llm-history-file="$llm_history_file" \
    --restore-chat-history \
    -m "'$*'"
}
