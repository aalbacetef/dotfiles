#!/usr/bin/env bash

venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # in case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "(venv:$venv) "
}

git_info() {
    branch_name=$(git status -b -s 2>/dev/null | grep '##' | cut -d' ' -f 2 | sed 's/\.\.\..*//' )

    if [[ "$branch_name" == "" ]]; then
        branch_name="not a repo"
    fi

    echo "$branch_name"
}

git_branch() {
    is_inside_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    if [[ "$is_inside_repo" == "true" ]]; then
		st_short=$(git status --porcelain)

        added=$( echo -n "$st_short" | grep -Ec '^A' )
        modified=$( echo -n "$st_short" | grep -Ec '^M|^ M' )
		renamed=$(echo -n "$st_short" | grep -Ec '^R' )
        deleted=$( echo -n "$st_short" | grep -Ec '^ D' )
        untracked=$( echo -n "$st_short" | grep -Ec '^\?\?' )

        branch_name="git ~ $(git_info) "
        status_output="Add: $added    Mod: $(expr $modified + $renamed)   Del: $deleted    Unt: $untracked"
#        echo " 	"
        echo -n " ["
        echo -n ' '$branch_name
        echo -n ' || '$status_output
        echo " ]"

		unset added
		unset modified
		unset deleted
		unset untracked

    else
        echo ""
    fi

}

get_branch_info() {
    b=$(git_branch)
    if [[ "$b" != "" ]]; then
        echo "$b"
    fi
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

PS1="\n$login_info $time_var $size_str $venv \n ~> $directory \n"'$git_str'" \n "'$ '


gitlab() {
	local repo=$(realpath $1)
	local name=$(basename $repo)

	git remote add gitlab ssh://gitlab:/aalbacetef/$name.git
}
