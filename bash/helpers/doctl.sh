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

###############################################
# Add the given inbound rules for the firewall
# with the corresponding ID.
#
# Arguments:
#  - ID of the firewall
#  - inbound rules
#
###############################################
doctl::add_rule() {
  local firewall_id="$1"
  local rule_to_add="$2"

  doctl compute firewall add-rules "$firewall_id" --inbound-rules "$rule_to_add"
}

###############################################
# Get the given inbound rules for the firewall
# with the corresponding ID.
#
# Arguments:
#  - ID of the firewall
# 
# Outputs:
#  - inbound rules 
#
###############################################
doctl::get_rules() {
  local firewall_id="$1"

  doctl compute firewall get "$firewall_id" --format InboundRules --no-header
}

#################################################
# Remove the given inbound rules for the firewall
# with the corresponding ID.
#
# Arguments:
#  - ID of the firewall
#  - inbound rules
#
#################################################
doctl::remove_rules() {
  local firewall_id="$1"
  local rules_to_delete="$2"

  doctl compute firewall remove-rules "$firewall_id" --inbound-rules "$rules_to_delete"
}

