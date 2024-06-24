#!/usr/bin/env bash 


############################################
# Get the value of the key in the specified
# env file.
#
# Arguments:
#  - path to the env file
#  - key to get 
#
# Outputs:
#  - value of the key, returns exit status 1 
#    if not found 
###########################################

env::get_value() {
  local filename="$1"
  local key="$2"

  if [ -z "$filename" ] ; then 
    echo "filename is not set"
    return 1 
  fi 

  if [ -z "$key" ]; then 
    echo "key is not set"
    return 1 
  fi 

  value=$(grep "$key=" "$filename"| cut -d'=' -f 2)
  
  if [ -z "$value" ]; then 
    return 1
  fi 

  echo "$value"
  return 0
}
