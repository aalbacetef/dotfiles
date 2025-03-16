#!/usr/bin/env bash

## use my ssh aliases for git repos
git config --global url."gitlab:".insteadOf "https://gitlab.com/"
git config --global url."github:".insteadOf "https://github.com"

# set default branch name
git config --global --unset-all init.defaultbranch
git config --global init.defaultbranch master

# use no fast forward as default merge strategy
git config --global --unset-all merge.ff
git config --global merge.ff false

# automatically rebase when pulling
git config --global --unset-all pull.rebase
git config --global pull.rebase true

# set excludes file
current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
excludes_file="$current_dir/git-excludesfile"

git config --global --unset-all core.excludesfile
git config --global core.excludesfile "$excludes_file"

# set meld as the merge tool
git config --global --unset-all merge.tool
git config --global merge.tool meld

# set nano as the default editor
git config --global core.editor nano
