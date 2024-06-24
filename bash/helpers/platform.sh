#!/usr/bin/env bash 

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
