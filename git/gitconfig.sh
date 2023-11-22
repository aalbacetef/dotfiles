
#!/usr/bin/env bash

## use my ssh aliases for git repors
git config --global url."gitlab:".insteadOf "https://gitlab.com/"
git config --global url."github:".insteadOf "https://github.com"

# set default branch name
git config --global init.defaultbranch master

# use no fast forward as default merge strategy
git config --global --add merge.ff false
