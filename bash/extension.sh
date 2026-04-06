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

########################################################
#
# Get an item matching NAME in the folder FOLDER
#
########################################################
bwi() {
  local name="$1"
  local folder="$2"

  if test -z "$name"; then
    echo "bwi NAME FOLDER:"
    echo "  find all items with name NAME in FOLDER"
    echo "error: NAME is empty"
    return 1
  fi

  if test -z "$folder"; then
    echo "bwi: find all items with name matching: NAME"
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

#########################################################
#
# Convert virtualbox Vagrant boxes into libvirt format
#
#########################################################
vagrant-pull() {
  # Requires `vagrant-mutate` plugin:
  # vagrant plugin install vagrant-mutate

  # Check if a box slug is provided as an argument.
  if test -z "$1"; then
    echo "Usage: $0 <box_slug> [source_provider] [target_provider]"
    echo "Example: $0 debian/jessie64 virtualbox libvirt"
    return 1
  fi

  BOX_SLUG=$1
  SOURCE_PROVIDER=${2:-"virtualbox"}
  TARGET_PROVIDER=${3:-"libvirt"}

  echo "==> Pulling box '${BOX_SLUG}' for provider '${SOURCE_PROVIDER}'..."
  vagrant box add --provider "${SOURCE_PROVIDER}" "${BOX_SLUG}"

  echo "==> Mutating box '${BOX_SLUG}' from '${SOURCE_PROVIDER}' to '${TARGET_PROVIDER}'..."
  vagrant mutate "${BOX_SLUG}" "${TARGET_PROVIDER}"

  echo "==> Removing original box '${BOX_SLUG}' for provider '${SOURCE_PROVIDER}'..."
  vagrant box remove "${BOX_SLUG}" --provider "${SOURCE_PROVIDER}" --force

  echo "==> Done. Box '${BOX_SLUG}' is now available for the '${TARGET_PROVIDER}' provider."
}

####################################
#
# Scaffold a directory for a module
#
####################################
mk-module() {
  if test -z "$1"; then
    echo "please pass in a module path"
    return 1
  fi

  local path_to_module="$DOTFILES/$1"
  local module_name="$(basename "$path_to_module")"
  local script_path="$path_to_module/__module.sh"

  echo "ensuring module exists: '$path_to_module'"

  mkdir -p "$path_to_module"

  if test -f "$script_path"; then
    echo "script already exists"
    return 0
  fi

  echo "scaffolding basic script..."

  echo '#!/usr/bin/env bash

current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

log() {
  now=$(date +"%H:%M:%S")
  echo "[{{ .ModuleName }} | $now]" "$@"
}
  ' >"$script_path"

  sed -i "s/{{ .ModuleName }}/$module_name/" "$script_path"

  chmod +x "$script_path"

  echo "done"
}

nix-develop-init() {
  local path_to="${1:-./flake.nix}"
  local dotfiles_dir="$(dirname "$current_dir")"
  echo "path_to: $path_to"
  "$dotfiles_dir/templates/nix-develop.sh" "$path_to"
}

g-ask() {
  ({
    mkd ~/.gemini-chat
    gemini
  })
}

dc-doc() {
  local name="$1"

  if test -z "$name"; then
    echo "name cannot be blank"
  fi

  curl -s "https://hub.docker.com/v2/repositories/library/$name/" | jq -r .full_description | glow -p -s dark
}

nd-enter() {
  nix develop --impure
}

nd-run() {
  nix develop --impure --command -- "$@"
}

dt() {
  date -u +"%Y-%m-%dT%H:%M:%SZ" "$@"
}

gh-doc() {
  local repo_path="$1"

  glow -s dark -p github.com/$repo_path
}

dot-help() {
  echo '
  HELPERS

    GENERAL 
      dc-doc             get Docker Hub README for image (IMAGE)
      gh-doc             get Github README for repo (REPO_PATH)
      nix-develop-init   bootstrap nix develop flake
      nd-run             run a command in nix develop (COMMAND)
      nd-enter           enter nix develop flake

    BITWARDEN 
      bwf                get folder ID based on name  (NAME)
      bw-folders         get all folder names
      bw-add-env         add an attachment to developer environment folder (NAME, FILENAME)
      bwi                get item based on name  (NAME, FOLDER)
      bw-mk-note         make a note (NAME, FOLDER)
  '
}

crushy() {
  set -ueo pipefail

  readonly HASH=$(pwd | sha1sum | cut -d' ' -f1)
  readonly STATE_PATH="${HOME}/.local/share/crush/projects/${HASH}"

  crush -D "${STATE_PATH}" "${@}"
}
