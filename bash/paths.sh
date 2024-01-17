#!/usr/bin/env bash

# set dotfiles path
export DOTFILES=/personal-files/dotfiles

# set gopath and goroot
export GOPATH="/personal-files/gopath"
export GOENV="$GOPATH/env"
export GOROOT="/personal-files/go"

# set zigpath
export ZIGPATH="/personal-files/zig"

# add custom binaries and golang to path
export PERSONAL_BIN="/personal-files/bin"
export PATH="$PERSONAL_BIN:$GOROOT/bin:$GOPATH/bin:$ZIGPATH:$PATH"
export WIREGUARD_TUNNEL_NAME="tunnel"

# vagrant.d
export VAGRANT_HOME=/media/arturo/cc6316ab-ead6-4170-a960-5ce437efd6fa/vms/vagrant.d

# add podman user-level service/socket as docker host
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
export SHADOWED_DOCKER_HOST=unix:///run/docker.sock

export NVM_DIR="$HOME/.nvm"

export PATH="$PATH:/home/arturo/.emacs.d/bin/"


export ANDROID_SDK_ROOT=/personal-files/android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export CAPACITOR_ANDROID_STUDIO_PATH=/personal-files/android/android-studio/bin/studio.sh

source $HOME/.nix-profile/etc/profile.d/nix.sh
export XDG_DATA_DIRS="/personal-files/apps:$XDG_DATA_DIRS"

export DENO_INSTALL="/personal-files/apps/deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# add nim paths
export PATH="$PATH:/personal-files/nim/bin"

# add taskwarrior rc file path 
export TASKDATA="/personal-files/work/taskwarrior"
export TASKRC="$TASKDATA/taskrc"
