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
