#!/usr/bin/env bash

source "$DOTFILES/bash/helpers/env.sh"
source "$DOTFILES/bash/helpers/platform.sh"

envrc="$DOTFILES/bash/env.rc"

if GO_BIN="$(go env GOPATH)/bin"; then
  export PATH="$GO_BIN:$PATH"
fi

export NVM_DIR="$HOME/.nvm"

export KITTY_CONFIG_DIRECTORY="$DOTFILES/kitty"

vagrant_home=$(env::get "$envrc" VAGRANT_HOME)
if test -n "$vagrant_home"; then 
  export VAGRANT_HOME="$vagrant_home"
fi

docker_host=$(env::get "$envrc" DOCKER_HOST)
if test -n "$docker_host"; then 
  export DOCKER_HOST="$docker_host"
fi 

shadowed_docker_host=$(env::get "$envrc" SHADOWED_DOCKER_HOST)
if test -n "$shadowed_docker_host"; then 
  export SHADOWED_DOCKER_HOST="$shadowed_docker_host"
fi

if platform::is_linux; then 
  xdg_data_dirs="$(env::get "$envrc" XDG_DATA_DIRS)"
  add_local_bin=$(env::get "$envrc" ADD_LOCAL_BIN)

  if test -n "$add_local_bin"; then 
    export PATH="/usr/local/bin:$PATH"
  fi

  if test -n "$xdg_data_dirs"; then 
    export XDG_DATA_DIRS="$xdg_data_dirs:$XDG_DATA_DIRS"
  fi 
fi
