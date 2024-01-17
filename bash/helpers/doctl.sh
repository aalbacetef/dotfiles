#!/usr/bin/env bash 


##########################################
# Get the ID of the digitalocean firewall 
# corresponding to "$NAME".
#
# Arguments:
#  - Name of the firewall 
#
# Outputs:
#  - ID of the firewall
##########################################
doctl::get_firewall_id() {
  local name="$1"
  if [[ "$name" == "" ]]; then
    echo "no id supplied"
    return 1
  fi

  doctl compute firewall list --format 'ID,Name' | grep -E "\s$name$" | cut -d' ' -f 1
}


