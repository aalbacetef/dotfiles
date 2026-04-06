#!/usr/bin/env fish

set skills_dir (realpath ~/.agents/skills/)
set local_dir (realpath (dirname (status --current-filename)))



for skill in (find $local_dir -maxdepth 1 -type d -not -name '.crush')
  # skip top level directory 
  if ! test "$skill" = "$local_dir" 
    printf "skill: %s\n" (basename $skill)
    set -l target $skills_dir/(basename $skill)

    ## link it 
    if ! test -e $target 
      printf "local_dir: %s => link: %s\n" $skill "$target"
      ln -s $skill $target

    else 
      printf "already present, skipping...\n"
    end

    printf "\n"
  end
end 
