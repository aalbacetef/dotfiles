#!/usr/bin/env bash 

readonly ERR_WRONG_PLATFORM=110

platform::get_os() {
  uname -o 
}

platform::is_linux() {
  local v="0"
  if [[ $(platform::get_os) = "Linux" ]]; then 
    v="1"
  fi 
  
  echo "$v"
}

platform::is_darwin() {
  local v="0"
  if [[ $(platform::get_os) = "Darwin" ]]; then
    v="1"
  fi 

  echo "$v" 
}
