#!/usr/bin/env bash

source "$DOTFILES/bash/helpers/env.sh"
source "$DOTFILES/bash/helpers/platform.sh"

envrc="$DOTFILES/bash/env.rc"

export GO_BIN="$(go env bin)"
export NVM_DIR="$HOME/.nvm"

export KITTY_CONFIG_DIRECTORY="$DOTFILES/kitty"

vagrant_home=$(env::get "$envrc" VAGRANT_HOME)
if [[ "$vagrant_home" != "" ]]; then 
  export VAGRANT_HOME="$vagrant_home"
fi

docker_host=$(env::get "$envrc" DOCKER_HOST)
if [[ "$docker_host" != "" ]]; then 
  export DOCKER_HOST="$docker_host"
fi 

shadowed_docker_host=$(env::get "$envrc" SHADOWED_DOCKER_HOST)
if [[ "$shadowed_docker_host" != "" ]]; then 
  export SHADOWED_DOCKER_HOST="$shadowed_docker_host"
fi

if [[ "$(platform::is_linux)"  == "1" ]]; then 
  xdg_data_dirs="$(env::get "$envrc" XDG_DATA_DIRS)"

  if [[ "$xdg_data_dirs" != "" ]]; then 
    export XDG_DATA_DIRS="$xdg_data_dirs:$XDG_DATA_DIRS"
  fi 
fi
