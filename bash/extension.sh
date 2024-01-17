#!/usr/bin/env bash

current_dir="$(dirname $(realpath $BASH_SOURCE))"

source "$current_dir"/helpers/platform.sh

function mkd() {
  local path="$1"

  mkdir -p "$path" && cd "$path"
}

function personal-ssh-ip() {
  local my_ip=$(curl -s ifconfig.me)
  local firewall_id=$(doctl compute firewall list --format 'ID,Name'| grep 'personal-ssh' | cut -d' ' -f 1)
  if [[ "$firewall_id" == "" ]]; then 
    echo "No firewall found"
    return 1
  fi
  
  echo "found firewall with id: $firewall_id"

  local rules_to_delete=$(doctl compute firewall get $firewall_id --format InboundRules --no-header)
  if [[ "$rules_to_delete" != "" ]]; then 
    echo "removing previous inbound rule: $rules_to_delete"
    doctl compute firewall remove-rules $firewall_id --inbound-rules "$rules_to_delete"
  fi
  
  local rule_to_add="protocol:tcp,ports:22,address:$my_ip"
  echo "adding inbound rule: $rule_to_add"
  doctl compute firewall add-rules $firewall_id --inbound-rules "$rule_to_add"
}


function remove-personal-ssh-ip() {
  local firewall_id=$(doctl compute firewall list --format 'ID,Name'| grep 'personal-ssh' | cut -d' ' -f 1)
  if [[ "$firewall_id" == "" ]]; then 
    echo "No firewall found"
    return 1
  fi
  
  echo "found firewall with id: $firewall_id"

  local rules_to_delete=$(doctl compute firewall get $firewall_id --format InboundRules --no-header)
  if [[ "$rules_to_delete" != "" ]]; then 
    echo "removing previous inbound rule: $rules_to_delete"
    doctl compute firewall remove-rules $firewall_id --inbound-rules "$rules_to_delete"
  fi
  
}


## DDO launcher. Added this because steam was struggling to launch DDO.
ddo-launch() {
  # should only run on linux
  if [[ "$(platform::is_linux)" != "1" ]]; then
    echo "only on linux"
    return $ERR_WRONG_PLATFORM
  fi


  local pfx=$(realpath ~/.steam/debian-installation/steamapps/compatdata/206480/pfx)
  local rootdir="$(realpath ~/.steam/debian-installation/steamapps/common/Dungeons\ and\ Dragons\ Online)"

  echo "prefix: $pfx"
  echo "rootdir: $rootdir"
  echo ""
  env WINEPREFIX=$pfx wine "$rootdir/DNDLauncher.exe"
}
