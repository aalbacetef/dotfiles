#!/usr/bin/env bash

## use my ssh aliases for git repos
git config --global url."gitlab:".insteadOf "https://gitlab.com/"
git config --global url."github:".insteadOf "https://github.com"

# set default branch name
git config --global init.defaultbranch master

# use no fast forward as default merge strategy
git config --global --add merge.ff false

# automatically rebase when pulling
git config --global --add pull.rebase true

# set excludes file
current_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
excludes_file="$current_dir/git-excludes-file"

git config --global --add core.excludesfile "$excludes_file"

# set meld as the merge tool
git config --global --add merge.tool meld
