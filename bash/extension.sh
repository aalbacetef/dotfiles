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
  local firewall_id
  local firewall_name="personal-ssh"
  local rules_to_delete
  local rule_to_add="protocol:tcp,ports:22,address:$my_ip"

  my_ip=$(curl -s ifconfig.me)

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
