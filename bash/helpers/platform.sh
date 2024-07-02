#!/usr/bin/env bash 

platform::get_os() {
  uname -o 
}

platform::is_linux() {
  if [[ $(platform::get_os) = "Linux" ]]; then 
    return 0
  fi 
  
  return 1
}

platform::is_darwin() {
  if [[ $(platform::get_os) = "Darwin" ]]; then
    return 0
  fi 

  return 1
}
