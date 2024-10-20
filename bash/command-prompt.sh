#!/usr/bin/env bash

########################################
#
# Print the venv info as (venv:$name)
#
# ######################################
venv_info() {
    local venv=''

    # strip out the path and just leave the env name
    if test -n "$VIRTUAL_ENV"; then
        venv="${VIRTUAL_ENV##*/}"
    fi

    if test -n "$venv"; then
        echo "(venv:$venv) "
    fi
}

##############################
#
# Print the git information.
#
##############################
git_branch_name() {
    branch_name=$(git status -b -s 2>/dev/null | grep '##' | cut -d' ' -f 2 | sed 's/\.\.\..*//')

    if test -n "$branch_name"; then
        echo "$branch_name"
    fi
}

git_branch() {
    local st_short
    local added
    local modified
    local renamed
    local deleted
    local untracked
    local branch_name
    local status_output

    st_short=$(git status --porcelain)

    added=$(echo -n "$st_short" | grep -Ec '^A')
    modified=$(echo -n "$st_short" | grep -Ec '^ M')
    renamed=$(echo -n "$st_short" | grep -Ec '^R')
    deleted=$(echo -n "$st_short" | grep -Ec '^ D')
    untracked=$(echo -n "$st_short" | grep -Ec '^\?\?')

    branch_name="git ~ $(git_branch_name) "
    status_output="Add: $added Mod: $(expr $modified + $renamed) Del: $deleted Unt: $untracked"

    str=$(printf " [ %s || %s ] " "$branch_name" "$status_output")
    printf "%s\n" "$str"
}

get_branch_info() {
    local is_inside_repo

    is_inside_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    if test "$is_inside_repo"; then
        git_branch
    fi

    echo " "
}

# size helpers
files_count="\$(ls -1 | wc -l | sed 's: ::g')"
cur_files_size="\$(ls -lah | grep -m 1 total | sed 's/total //')"

# color helpers
RESET_COLOR='\[\033[00m\]'
RED='\[\033[01;31m\]'
GREEN='\[\033[01;32m\]'
BLUE='\[\033[01;34m\]'
YELLOW="\[\033[1;33m\]"
PINK="\[\033[1;90m\]"

login_info='${debian_chroot:+($debian_chroot)}'$GREEN'\u@\h'$RESET_COLOR
time_var=$RED' \t'$RESET_COLOR
size_str=$YELLOW" files: $files_count "$RESET_COLOR
directory=$BLUE'\w'$RESET_COLOR
venv=$PINK'$(venv_info)'$RESET_COLOR

PROMPT_COMMAND='export git_str=$( get_branch_info )'

## disable venv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

export PS1="\n$login_info $time_var $size_str $venv \n ~> $directory \n"'$git_str''$ '
