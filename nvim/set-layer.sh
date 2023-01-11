#!/usr/bin/env bash

##
## This script will set up the layer of choice
##

## Available layers: 
##
##  - nvchad (need to implement)
##  - astronvim
##

layer="$1"

dname=$(dirname "$0")
this_dir=$(realpath $dname)
backup_path="$this_dir/backups"

mkdir -p $backup_path

if [[ "$layer" == "" ]]; then
  echo "no layer specified"
  echo "available: nvchand, astronvim"
  exit 1
fi

backup_dir() {
  if [[ "$1" == "" ]]; then 
    return
  fi  
  
  if [[ "$2" == "" ]]; then
    return
  fi

  target="$1"
  name="$2"
  now="$3"

  if [[ ! -d "$1" ]]; then
    return
  fi

  fname="$backup_path/$name.backup.$now.tar"
  echo "saving backup to: "$fname
  tar -cf $fname $target
  echo "back up done"
}

set_layer() {
  now=$(date +%Y-%m-%d--%H-%M-%S)
  if [[ "$layer" == "nvchad" ]]; then
    echo "nvchad: not yet implemented"
    return 1
  fi

  if [[ "$layer" == "astronvim" ]]; then

    if [[ -d "~/.config/nvim" ]]; then
      backup_dir "~/.config/nvim" "config.nvim" $now
      rm -rf "~/.config/nvim"
    fi

    if [[ -d "~/.local/share/nvim" ]]; then
      backup_dir "~/.local/share/nvim" "local.share.nvim" $now
      rm -rf "~/.local/share/nvim"
    fi


    echo "Copying AstroNvim to ~/.config/nvim"
    cp -r $this_dir/AstroNvim ~/.config/nvim
    
    echo "initializing nvim"
    nvim +PackerSync
  fi
}


set_layer $layer
